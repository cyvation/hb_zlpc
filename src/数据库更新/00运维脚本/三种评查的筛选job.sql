----------------------------------------------
-- Export file for user ZLPC                --
-- Created by caomin on 2018/4/30, 17:36:16 --
----------------------------------------------

spool ���������ɸѡjob.log

prompt
prompt Creating procedure PROC_CGPCSX
prompt ==============================
prompt
CREATE OR REPLACE PROCEDURE proc_cgpcsx IS
        p_gzdwbm CHAR(6) DEFAULT '420000';
        v_pcflbm CHAR(3) DEFAULT '001';--����
        v_count_wsx   NUMBER DEFAULT 0;
        v_count_ysx   NUMBER DEFAULT 0;
        v_curdate DATE;
        v_gzrqbng DATE; --����������� ��ʼ
        v_gzrqend DATE; --����������� ����
        cur_sql  CLOB;
        v_sql    CLOB;
        v_str    CLOB;
        v_errorcode VARCHAR2(4000);
        v_errortext VARCHAR2(4000);
        v_cursor SYS_REFCURSOR; -- ��ʱ�α�
        TYPE record_type IS RECORD(
            id   NUMBER,
            gzbm VARCHAR2(100),
            gzmc VARCHAR2(300),
            sxcx VARCHAR2(1000),
            cxcs VARCHAR2(4000),
            fgzbm VARCHAR2(100),
            fgzmc VARCHAR2(300),
            ywtx VARCHAR2(13));
        v_record record_type;
        v_st DATE default SYSDATE; --��ʱ��ʼ
        v_ed DATE default SYSDATE; --��ʱ����
        v_index NUMBER DEFAULT 0; --ѭ������
    BEGIN
        v_sql := ' ';
        v_str := ' ';
        
        v_curdate := SYSDATE;

        -- �ж��Ƿ��״�ִ��Job
        SELECT COUNT(1) INTO v_count_wsx FROM yx_pc_sxjl WHERE pcflbm = v_pcflbm;
        SELECT COUNT(1) INTO v_count_ysx FROM yx_pc_jbxx WHERE pcflbm = v_pcflbm;
        IF v_count_wsx + v_count_ysx <= 0
        THEN
            v_gzrqbng := to_date('20131231000000', 'yyyymmddhh24miss');
        ELSE
            v_gzrqbng := v_curdate - 2;
        END IF;
        v_gzrqend := v_curdate + 1;
        v_gzrqbng := to_date('20170101000000', 'yyyymmddhh24miss');
        v_gzrqend := to_date('20171231235959', 'yyyymmddhh24miss');
        -- 1.��հ����б�
        /*EXECUTE IMMEDIATE ' DELETE FROM yx_pc_sxjl WHERE pcflbm = :pcflbm AND wcbzrq > :wcbzrq'
            USING v_pcflbm, v_gzrqbng;
*/
       --2.1��ȡ����ɸѡ�����б�
        cur_sql := 'SELECT rownum id, gzbm, gzmc, sxcx, cxcs, fgzbm, fgzmc, ywtx
                    FROM xt_pc_sxgz
                   WHERE length(sxcx) > 0 AND (sm IS NULL OR sm <> ''�Զ�ɸѡʱ��ִ�У��������Զ����ѯʹ��'')
                     AND pcflbm=:pcflbm';


        -- ɸѡ����������λ����
        cur_sql := cur_sql || pkg_common.func_get_queryequalsql('dwbm', p_gzdwbm);
        -- ɸѡ���������������
        cur_sql := cur_sql || pkg_common.func_get_queryequalsql('pcflbm', v_pcflbm);

        --����ɸѡ�����ȡ����
        OPEN v_cursor FOR cur_sql USING v_pcflbm;
        LOOP
          begin
            FETCH v_cursor
                INTO v_record;
            EXIT WHEN v_cursor%NOTFOUND;
              v_sql:=NULL;
              v_str:='';

            EXECUTE IMMEDIATE 'SELECT ' || v_record.sxcx ||
                              '(:gzbm, :cbdwbm, :gzrqbng, :gzrqend, :zdycxtj) s FROM DUAL'
                INTO v_str
                USING v_record.gzbm, '', v_gzrqbng, v_gzrqend, v_record.cxcs;


                        -- 2.2.ɸѡ����Ӧ���򳣹永�� :pcflbm :sm
            v_sql := 'INSERT INTO yx_pc_sxjl
                      (pcflbm, dwbm, bmsah, tysah, ajmc, ajlb_bm, ajlb_mc,
                       dwmc, bmbm, bmmc, cbrgh, cbrmc, slrq, wcrq, sm, sxgzbm, wcbzrq,sxgzmc,fgzbm,fgzmc,ywtx)
                      SELECT :pcflbm, x.cbdw_bm, x.bmsah, x.tysah, x.ajmc, x.ajlb_bm, x.ajlb_mc,
                             x.cbdw_mc, x.cbbm_bm, x.cbbm_mc, x.cbrgh, x.cbr, x.slrq, x.wcrq, :sm,:gzbm, a.wcbzrq,:gzmc
                             ,:fgzbm,:fgzmc,:ywtx
                        FROM (' || v_str || '  ) a
                       INNER JOIN tyyw_gg_ajjbxx' || pkg_default.g_tyyw_link || ' x
                          ON a.bmsah = x.bmsah
                       WHERE 1 = 1
                         AND NOT EXISTS (SELECT 1
                                           FROM yx_pc_jbxx jb
                                          WHERE jb.sfsc=''N''
                                            AND a.bmsah = jb.bmsah)
                         AND NOT EXISTS (SELECT 1
                                   FROM (SELECT bmsah_y bmsah
                                           FROM yx_ag_cajl' || pkg_default.g_tyyw_link || '
                                          WHERE sfsc = ''N''
                                          UNION
                                         SELECT bmsah_b bmsah
                                           FROM yx_ag_bajl' || pkg_default.g_tyyw_link || '
                                          WHERE sfsc = ''N''
                                        ) jb
                                  WHERE a.bmsah = jb.bmsah)';

          --   INSERT INTO test_t VALUES (to_number(to_char(SYSDATE,'yyyymmdd')),v_sql,SYSDATE);COMMIT;

          
           IF v_sql IS NOT NULL THEN
             v_st :=SYSDATE;
             EXECUTE IMMEDIATE v_sql
                USING v_pcflbm, '0',v_record.gzbm,v_record.gzmc,v_record.fgzbm,v_record.fgzmc,v_record.ywtx;
             v_ed := SYSDATE;
                
             --�ɹ�ִ��
             INSERT INTO yx_rz_xt(logid,logdatetime,loglevel,logger,message,SQL) 
              VALUES(seq_yx_rz_xt.nextval,SYSDATE,'success',v_index||'[����JOB]proc_cgpcsx->'||v_record.gzmc,'ִ�гɹ�(��):'||ceil((v_ed-v_st)*24*60*60),v_sql);
           END IF;
           
        EXCEPTION
           WHEN OTHERS THEN
           --�����쳣 
           v_errorcode := SQLCODE;   
           v_errortext := SUBSTR(SQLERRM, 1, 3000);   
           INSERT INTO yx_rz_xt(logid,logdatetime,loglevel,logger,message,SQL) 
              VALUES(seq_yx_rz_xt.nextval,SYSDATE,'error',v_index||'[����JOB]proc_cgpcsx->'||v_record.gzmc,v_errorcode||v_errortext,v_sql);
        END;
           v_index := v_index+1;
           COMMIT;
          
        END LOOP;

        IF v_cursor%ISOPEN
        THEN
            CLOSE v_cursor;
        END IF;                                             

        


    END;
/

prompt
prompt Creating procedure PROC_SJPCSX
prompt ==============================
prompt
CREATE OR REPLACE PROCEDURE proc_sjpcsx IS
        p_gzdwbm CHAR(6) DEFAULT '420000';
        v_pcflbm CHAR(3) DEFAULT '007';--���
        v_count_wsx   NUMBER DEFAULT 0;
        v_count_ysx   NUMBER DEFAULT 0;
        v_curdate DATE;
        v_gzrqbng DATE; --����������� ��ʼ
        v_gzrqend DATE; --����������� ����
        cur_sql  CLOB;
        v_sql    CLOB;
        v_str    CLOB;
        v_errorcode VARCHAR2(4000);
        v_errortext VARCHAR2(4000);
        v_cursor SYS_REFCURSOR; -- ��ʱ�α�
        TYPE record_type IS RECORD(
            id   NUMBER,
            gzbm VARCHAR2(100),
            gzmc VARCHAR2(300),
            sxcx VARCHAR2(1000),
            cxcs VARCHAR2(4000),
            fgzbm VARCHAR2(100),
            fgzmc VARCHAR2(300),
            ywtx VARCHAR2(13));
        v_record record_type;
        v_st DATE default SYSDATE; --��ʱ��ʼ
        v_ed DATE default SYSDATE; --��ʱ����
        v_index NUMBER DEFAULT 0; --ѭ������
    BEGIN
        v_sql := ' ';
        v_str := ' ';
        
        v_curdate := SYSDATE;

        -- �ж��Ƿ��״�ִ��Job
        SELECT COUNT(1) INTO v_count_wsx FROM yx_pc_sxjl WHERE pcflbm = v_pcflbm;
        SELECT COUNT(1) INTO v_count_ysx FROM yx_pc_jbxx WHERE pcflbm = v_pcflbm;
        IF v_count_wsx + v_count_ysx <= 0
        THEN
            v_gzrqbng := to_date('20131231000000', 'yyyymmddhh24miss');
        ELSE
            v_gzrqbng := v_curdate - 2;
        END IF;
        v_gzrqend := v_curdate + 1;
        v_gzrqbng :=  to_date('20131231000000', 'yyyymmddhh24miss');
        v_gzrqend := to_date('20161231235959', 'yyyymmddhh24miss');
        -- 1.��հ����б�
        /*EXECUTE IMMEDIATE ' DELETE FROM yx_pc_sxjl WHERE pcflbm = :pcflbm AND wcbzrq > :wcbzrq'
            USING v_pcflbm, v_gzrqbng;
*/
       --2.1��ȡ���ɸѡ�����б�
        cur_sql := 'SELECT rownum id, gzbm, gzmc, sxcx, cxcs, fgzbm, fgzmc, ywtx
                    FROM xt_pc_sxgz
                   WHERE length(sxcx) > 0 AND (sm IS NULL OR sm <> ''�Զ�ɸѡʱ��ִ�У��������Զ����ѯʹ��'')
                     AND pcflbm=:pcflbm';


        -- ɸѡ����������λ����
        cur_sql := cur_sql || pkg_common.func_get_queryequalsql('dwbm', p_gzdwbm);
        -- ɸѡ���������������
        cur_sql := cur_sql || pkg_common.func_get_queryequalsql('pcflbm', v_pcflbm);

        --����ɸѡ�����ȡ����
        OPEN v_cursor FOR cur_sql USING v_pcflbm;
        LOOP
          begin
            FETCH v_cursor
                INTO v_record;
            EXIT WHEN v_cursor%NOTFOUND;
              v_sql:=NULL;
              v_str:='';

            EXECUTE IMMEDIATE 'SELECT ' || v_record.sxcx ||
                              '(:gzbm, :cbdwbm, :gzrqbng, :gzrqend, :zdycxtj) s FROM DUAL'
                INTO v_str
                USING v_record.gzbm, '', v_gzrqbng, v_gzrqend, v_record.cxcs;


                        -- 2.2.ɸѡ����Ӧ���򳣹永�� :pcflbm :sm
            v_sql := 'INSERT INTO yx_pc_sxjl
                      (pcflbm, dwbm, bmsah, tysah, ajmc, ajlb_bm, ajlb_mc,
                       dwmc, bmbm, bmmc, cbrgh, cbrmc, slrq, wcrq, sm, sxgzbm, wcbzrq,sxgzmc,fgzbm,fgzmc,ywtx)
                      SELECT :pcflbm, x.cbdw_bm, x.bmsah, x.tysah, x.ajmc, x.ajlb_bm, x.ajlb_mc,
                             x.cbdw_mc, x.cbbm_bm, x.cbbm_mc, x.cbrgh, x.cbr, x.slrq, x.wcrq, :sm,:gzbm, a.wcbzrq,:gzmc
                             ,:fgzbm,:fgzmc,:ywtx
                        FROM (' || v_str || '  ) a
                       INNER JOIN tyyw_gg_ajjbxx' || pkg_default.g_tyyw_link || ' x
                          ON a.bmsah = x.bmsah
                       WHERE 1 = 1
                         AND NOT EXISTS (SELECT 1
                                           FROM yx_pc_jbxx jb
                                          WHERE jb.sfsc=''N''
                                            AND a.bmsah = jb.bmsah)
                         AND NOT EXISTS (SELECT 1
                                   FROM (SELECT bmsah_y bmsah
                                           FROM yx_ag_cajl' || pkg_default.g_tyyw_link || '
                                          WHERE sfsc = ''N''
                                          UNION
                                         SELECT bmsah_b bmsah
                                           FROM yx_ag_bajl' || pkg_default.g_tyyw_link || '
                                          WHERE sfsc = ''N''
                                        ) jb
                                  WHERE a.bmsah = jb.bmsah)';

          --   INSERT INTO test_t VALUES (to_number(to_char(SYSDATE,'yyyymmdd')),v_sql,SYSDATE);COMMIT;

          
           IF v_sql IS NOT NULL THEN
             v_st :=SYSDATE;
             EXECUTE IMMEDIATE v_sql
                USING v_pcflbm, '0',v_record.gzbm,v_record.gzmc,v_record.fgzbm,v_record.fgzmc,v_record.ywtx;
             v_ed := SYSDATE;
                
             --�ɹ�ִ��
             INSERT INTO yx_rz_xt(logid,logdatetime,loglevel,logger,message,SQL) 
              VALUES(seq_yx_rz_xt.nextval,SYSDATE,'success',v_index||'[���JOB]proc_cgpcsx->'||v_record.gzmc,'ִ�гɹ�(��):'||ceil((v_ed-v_st)*24*60*60),v_sql);
           END IF;
           
        EXCEPTION
           WHEN OTHERS THEN
           --�����쳣 
           v_errorcode := SQLCODE;   
           v_errortext := SUBSTR(SQLERRM, 1, 3000);   
           INSERT INTO yx_rz_xt(logid,logdatetime,loglevel,logger,message,SQL) 
              VALUES(seq_yx_rz_xt.nextval,SYSDATE,'error',v_index||'[���JOB]proc_cgpcsx->'||v_record.gzmc,v_errorcode||v_errortext,v_sql);
        END;
           v_index := v_index+1;
           COMMIT;
          
        END LOOP;

        IF v_cursor%ISOPEN
        THEN
            CLOSE v_cursor;
        END IF;                                             

        


    END;
/

prompt
prompt Creating procedure PROC_ZDPCSX
prompt ==============================
prompt
CREATE OR REPLACE PROCEDURE proc_zdpcsx IS
        p_gzdwbm CHAR(6) DEFAULT '420000';
        v_pcflbm CHAR(3) DEFAULT '008';
        v_count_wsx   NUMBER DEFAULT 0;
        v_count_ysx   NUMBER DEFAULT 0;
        v_curdate DATE;
        v_gzrqbng DATE; --����������� ��ʼ
        v_gzrqend DATE; --����������� ����
        cur_sql  CLOB;
        v_sql    CLOB;
        v_str    CLOB;
        v_errorcode VARCHAR2(4000);
        v_errortext VARCHAR2(4000);
        v_cursor SYS_REFCURSOR; -- ��ʱ�α�
        TYPE record_type IS RECORD(
            id   NUMBER,
            gzbm VARCHAR2(100),
            gzmc VARCHAR2(300),
            sxcx VARCHAR2(1000),
            cxcs VARCHAR2(4000),
            fgzbm VARCHAR2(100),
            fgzmc VARCHAR2(300),
            ywtx VARCHAR2(13));
        v_record record_type;
        v_st DATE default SYSDATE; --��ʱ��ʼ
        v_ed DATE default SYSDATE; --��ʱ����
        v_index NUMBER DEFAULT 0; --ѭ������
    BEGIN
        v_sql := ' ';
        v_str := ' ';
        
        v_curdate := SYSDATE;

        -- �ж��Ƿ��״�ִ��Job
        SELECT COUNT(1) INTO v_count_wsx FROM yx_pc_sxjl WHERE pcflbm = v_pcflbm;
        SELECT COUNT(1) INTO v_count_ysx FROM yx_pc_jbxx WHERE pcflbm = v_pcflbm;
        IF v_count_wsx + v_count_ysx <= 0
        THEN
            v_gzrqbng := to_date('20131231000000', 'yyyymmddhh24miss');
        ELSE
            v_gzrqbng := v_curdate - 2;
        END IF;
        v_gzrqend := v_curdate + 1;
        v_gzrqbng :=  to_date('20131231000000', 'yyyymmddhh24miss');
        v_gzrqend := to_date('20161231235959', 'yyyymmddhh24miss');
        -- 1.��հ����б�
        /*EXECUTE IMMEDIATE ' DELETE FROM yx_pc_sxjl WHERE pcflbm = :pcflbm AND wcbzrq > :wcbzrq'
            USING v_pcflbm, v_gzrqbng;
*/
       --2.1��ȡ�ص�ɸѡ�����б�
        cur_sql := 'SELECT rownum id, gzbm, gzmc, sxcx, cxcs, fgzbm, fgzmc, ywtx
                    FROM xt_pc_sxgz
                   WHERE length(sxcx) > 0 AND (sm IS NULL OR sm <> ''�Զ�ɸѡʱ��ִ�У��������Զ����ѯʹ��'')
                     AND fgzbm is not null';


        -- ɸѡ����������λ����
        cur_sql := cur_sql || pkg_common.func_get_queryequalsql('dwbm', p_gzdwbm);
        -- ɸѡ���������������
        cur_sql := cur_sql || pkg_common.func_get_queryequalsql('pcflbm', v_pcflbm);

        --����ɸѡ�����ȡ����
        OPEN v_cursor FOR cur_sql;
        LOOP
          begin
            FETCH v_cursor
                INTO v_record;
            EXIT WHEN v_cursor%NOTFOUND;
              v_sql:=NULL;
              v_str:='';

            EXECUTE IMMEDIATE 'SELECT ' || v_record.sxcx ||
                              '(:gzbm, :cbdwbm, :gzrqbng, :gzrqend, :zdycxtj) s FROM DUAL'
                INTO v_str
                USING v_record.gzbm, '', v_gzrqbng, v_gzrqend, v_record.cxcs;


                        -- 2.2.ɸѡ����Ӧ�����ص㰸�� :pcflbm :sm
            v_sql := 'INSERT INTO yx_pc_sxjl
                      (pcflbm, dwbm, bmsah, tysah, ajmc, ajlb_bm, ajlb_mc,
                       dwmc, bmbm, bmmc, cbrgh, cbrmc, slrq, wcrq, sm, sxgzbm, wcbzrq,sxgzmc,fgzbm,fgzmc,ywtx)
                      SELECT :pcflbm, x.cbdw_bm, x.bmsah, x.tysah, x.ajmc, x.ajlb_bm, x.ajlb_mc,
                             x.cbdw_mc, x.cbbm_bm, x.cbbm_mc, x.cbrgh, x.cbr, x.slrq, x.wcrq, :sm,:gzbm, a.wcbzrq,:gzmc
                             ,:fgzbm,:fgzmc,:ywtx
                        FROM (' || v_str || '  ) a
                       INNER JOIN tyyw_gg_ajjbxx' || pkg_default.g_tyyw_link || ' x
                          ON a.bmsah = x.bmsah
                       WHERE 1 = 1
                         AND NOT EXISTS (SELECT 1
                                           FROM yx_pc_jbxx jb
                                          WHERE jb.sfsc=''N''
                                            AND a.bmsah = jb.bmsah)
                         AND NOT EXISTS (SELECT 1
                                   FROM (SELECT bmsah_y bmsah
                                           FROM yx_ag_cajl' || pkg_default.g_tyyw_link || '
                                          WHERE sfsc = ''N''
                                          UNION
                                         SELECT bmsah_b bmsah
                                           FROM yx_ag_bajl' || pkg_default.g_tyyw_link || '
                                          WHERE sfsc = ''N''
                                        ) jb
                                  WHERE a.bmsah = jb.bmsah)';

          --   INSERT INTO test_t VALUES (to_number(to_char(SYSDATE,'yyyymmdd')),v_sql,SYSDATE);COMMIT;

          
           IF v_sql IS NOT NULL THEN
             v_st :=SYSDATE;
             EXECUTE IMMEDIATE v_sql
                USING v_pcflbm, '0',v_record.gzbm,v_record.gzmc,v_record.fgzbm,v_record.fgzmc,v_record.ywtx;
             v_ed := SYSDATE;
                
             --�ɹ�ִ��
             INSERT INTO yx_rz_xt(logid,logdatetime,loglevel,logger,message,SQL) 
              VALUES(seq_yx_rz_xt.nextval,SYSDATE,'success',v_index||'[�ص�JOB]proc_zdpcsx->'||v_record.gzmc,'ִ�гɹ�(��):'||ceil((v_ed-v_st)*24*60*60),v_sql);
           END IF;
           
        EXCEPTION
           WHEN OTHERS THEN
           --�����쳣 
           v_errorcode := SQLCODE;   
           v_errortext := SUBSTR(SQLERRM, 1, 3000);   
           INSERT INTO yx_rz_xt(logid,logdatetime,loglevel,logger,message,SQL) 
              VALUES(seq_yx_rz_xt.nextval,SYSDATE,'error',v_index||'[�ص�JOB]proc_zdpcsx->'||v_record.gzmc,v_errorcode||v_errortext,v_sql);
        END;
           v_index := v_index+1;
           COMMIT;
          
        END LOOP;

        IF v_cursor%ISOPEN
        THEN
            CLOSE v_cursor;
        END IF;                                             

        


    END;
/


spool off
