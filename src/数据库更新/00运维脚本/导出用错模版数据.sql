-- Create table
create table TEMP_ERRMB
(
  YWTX    VARCHAR2(200),
  YWTX_MC VARCHAR2(200),
  AJLB_BM VARCHAR2(200),
  AJLB_MC VARCHAR2(200),
  BARS    NUMBER,
  BJAJS   NUMBER,
  PCRYS   NUMBER,
  PCAJS   NUMBER
)
tablespace ZLPC
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64
    next 1
    minextents 1
    maxextents unlimited
  );

 --�ô�ģ�������
 create table temp_errmb_aj as
 SELECT d.dwmc pcdwmc,l.pcflmc , p.*
  FROM v_pcajxx p
 INNER JOIN temp_errmb t ON p.AJLB_BM = t.ajlb_bm
                        AND p.ywtx = t.ywtx
  INNER JOIN xt_tj_dw d ON p.PCDWBM=d.dwbm
  INNER JOIN xt_pc_lb l ON p.PCFLBM=l.pcflbm
 ORDER BY p.ywtx,
          p.AJLB_BM,
          p.PCDWBM,
          p.PCR_DWMC,
          p.PCR_MC,
          p.PCFLBM,
          p.BMSAH;

update yx_pc_jbxx j set j.sfsc='Y' where j.pcslbm in (select pcslbm from temp_errmb_aj);
--������ܰ�����

WITH  
   bjtab AS (SELECT * from v_bjajxx WHERE 1=1),  
   pctab AS (SELECT * from v_pcajxx WHERE 1=1),
   hztab AS( 
     --������ʱ��start
      SELECT u.ywtx,u.ajlb_bm,
        SUM(decode(coltype,'bars',cnt,0)) bars, --�참����
        SUM(decode(coltype,'bjajs',cnt,0)) bjajs, --��᰸����
        SUM(decode(coltype,'pcrys',cnt,0)) pcrys, --������Ա��
        SUM(decode(coltype,'pcajs',cnt,0)) pcajs, --���鰸����
        'N' sfhj
      FROM 
      (
        --�참����
        SELECT ywtx,ajlb_bm, count(*) cnt, 'bars' coltype from ( SELECT DISTINCT ywtx,ajlb_bm,cbdwbm ,cbrgh from bjtab ) a GROUP BY ywtx,ajlb_bm
        UNION ALL
        --��᰸����
        SELECT ywtx,ajlb_bm, count(*) cnt, 'bjajs' coltype from  bjtab  a GROUP BY ywtx,ajlb_bm
        UNION ALL
        --������Ա��
        SELECT ywtx,ajlb_bm, count(*) cnt, 'pcrys' coltype from ( SELECT DISTINCT ywtx,ajlb_bm,pcr_dwbm,pcr_gh from pctab v ) a GROUP BY ywtx,ajlb_bm
        UNION ALL
        --���鰸����
        SELECT ywtx,ajlb_bm, count(bmsah) cnt, 'pcajs' coltype from ( SELECT DISTINCT ywtx,ajlb_bm,bmsah from pctab v ) a GROUP BY ywtx,ajlb_bm
      ) u 
      GROUP BY u.ywtx,u.ajlb_bm 
  ) --������ʱ��end
  ,txtab AS (--ҵ�����ߡ����������ʱ��ֻͳ������ϵͳ����ֹ������start
    SELECT pctx.ywtx,
      (CASE WHEN pctx.ywtx = '-1' AND pctx.ajlb_bm='-1' THEN '�ϼ�' WHEN  pctx.ywtx != '-1' AND pctx.ajlb_bm='-1' THEN d.mc ELSE d.mc END  ) ywtx_mc,
      pctx.ajlb_bm,ajlb.ajlbmc ajlb_mc 
    FROM 
    (
      SELECT '-1' ywtx,'-1' ajlb_bm FROM dual --�����ܼ�
      UNION ALL
      SELECT ywtx,'-1' ajlb_bm FROM pctab GROUP BY ywtx --�������ߺϼ�
      UNION ALL
      SELECT ywtx,ajlb_bm
        FROM pctab
       GROUP BY ywtx, ajlb_bm
    ) pctx 
   LEFT JOIN xt_pc_dm d ON pctx.ywtx=d.dm
   LEFT JOIN xt_dm_ajlbbm@tyyw_link.net ajlb ON pctx.ajlb_bm=ajlb.ajlbbm
  ) --ҵ�����ߡ����������ʱ��ֻͳ������ϵͳ����ֹ������end
--�����start  
 SELECT
   (CASE WHEN y.ywtx = '-1' AND y.ajlb_bm='-1' THEN '100000' WHEN  y.ywtx != '-1' AND y.ajlb_bm='-1' THEN y.ywtx ELSE y.ywtx||y.ajlb_bm END  ) ID,
   (CASE WHEN y.ywtx = '-1' AND y.ajlb_bm='-1' THEN '-1' WHEN  y.ywtx != '-1' AND y.ajlb_bm='-1' THEN '100000' ELSE y.ywtx END  ) pid,
   (CASE WHEN y.ywtx = '-1' AND y.ajlb_bm='-1' THEN '�ϼ�' WHEN  y.ywtx != '-1' AND y.ajlb_bm='-1' THEN x.ywtx_mc||'(�ϼ�)' ELSE x.ajlb_mc END  ) NAME,
    y.ywtx,x.ywtx_mc,y.ajlb_bm,x.ajlb_mc,
    y.bars "�참����",y.bjajs "��᰸����",y.pcrys "������Ա��",y.pcajs "���鰸����"
    ,to_char(decode(y.bjajs,0,0,y.pcajs*100/y.bjajs),'fm999999990.009')||'%' "���������4/2��"
    ,round(decode(y.bars,0,0,(y.pcajs/y.bars)),4)   "�˾����������4/1��"
    ,round(decode(y.pcrys,0,0,(y.pcajs/y.pcrys)),4)  "�˾�����������4/3��" 
    ,y.sfhj "�Ƿ�ϼ���"
  FROM 
    (--��������start
     SELECT ywtx,ajlb_bm,bars,bjajs,pcrys,pcajs,sfhj from hztab
      UNION ALL
      --���Ӻϼ���
      SELECT nvl(ywtx,'-1') ywtx,'-1',sum(bars),sum(bjajs),sum(pcrys),sum(pcajs),'Y' sfhj
       FROM hztab  GROUP BY ROLLUP (ywtx)   
     ) y--��������end
  INNER JOIN txtab x ON x.ywtx=y.ywtx AND x.ajlb_bm=y.ajlb_bm
  --ֻ��ʾ����������0��
         WHERE y.pcajs >0 AND y.bjajs=0
  ORDER by x.ywtx,x.ajlb_bm   
 --�������end
 ;
 


 

