--������������-������
--�����	���鰸����	�����	���ʰ�����	����ռ��  �ϸ񰸼�����	�ϸ�ռ��	覴ð�����	覴�ռ��	���ϸ񰸼���	���ϸ�ռ��
WITH 
   bjtab AS (SELECT * from v_bjajxx WHERE 1=1),  
   pctab AS (SELECT * from v_pcajxx WHERE 1=1),
   hztab AS (
   --������ʱ��start
     SELECT u.ywtx,u.ajlb_bm,
      SUM(decode(coltype,'bjajs',cnt,0)) bjajs, --��᰸����
      SUM(decode(coltype,'pcajs',cnt,0)) pcajs, --���鰸����
      SUM(decode(coltype,'yzajs',cnt,0)) yzajs, --���ʰ�����
      SUM(decode(coltype,'hgajs',cnt,0)) hgajs, --�ϸ񰸼���
      SUM(decode(coltype,'xcajs',cnt,0)) xcajs, --覴ð�����
      SUM(decode(coltype,'bhgajs',cnt,0)) bhgajs,  --���ϸ񰸼���
      'N' sfhj
      from (
            --��᰸����
            SELECT ywtx,ajlb_bm, COUNT(*) cnt, 'bjajs' coltype FROM bjtab GROUP BY ywtx,ajlb_bm
            UNION ALL
            --���鰸����
            SELECT ywtx,ajlb_bm, COUNT(bmsah) cnt, 'pcajs' coltype FROM ( SELECT DISTINCT ywtx,ajlb_bm,bmsah from pctab ) a GROUP BY a.ywtx,a.ajlb_bm
            UNION ALL
            SELECT ywtx,ajlb_bm,COUNT(bmsah) cnt, 'yzajs' coltype FROM pctab WHERE  pcjl='���ʰ���' GROUP BY ywtx,ajlb_bm 
            UNION ALL
            SELECT ywtx,ajlb_bm,COUNT(bmsah) cnt, 'hgajs' coltype FROM pctab WHERE  pcjl='�ϸ񰸼�' GROUP BY ywtx,ajlb_bm 
            UNION ALL
            SELECT ywtx,ajlb_bm,COUNT(bmsah) cnt, 'xcajs' coltype FROM pctab WHERE  pcjl='覴ð���' GROUP BY ywtx,ajlb_bm 
            UNION ALL
            SELECT ywtx,ajlb_bm,COUNT(bmsah) cnt, 'bhgajs' coltype FROM pctab WHERE  pcjl='���ϸ񰸼�' GROUP BY ywtx,ajlb_bm 
        ) u 
      GROUP BY u.ywtx,u.ajlb_bm 
     --������ʱ��end   
     )
   ,txtab AS (--ҵ�����ߡ����������ʱ��ֻͳ������ϵͳ����ֹ������start
     SELECT pctx.ywtx,
       (CASE WHEN pctx.ywtx = '-1' AND pctx.ajlb_bm='-1' THEN '�ϼ�' WHEN  pctx.ywtx != '-1' AND pctx.ajlb_bm='-1' THEN d.mc ELSE d.mc END  ) ywtx_mc,
       pctx.ajlb_bm,ajlb.ajlbmc ajlb_mc 
     FROM 
     (
      SELECT '-1' ywtx,'-1' ajlb_bm FROM dual --�����ܼ�
      UNION ALL
      SELECT ywtx,'-1' ajlb_bm FROM v_pcajxx GROUP BY ywtx --�������ߺϼ�
      UNION ALL
      SELECT ywtx,ajlb_bm
        FROM v_pcajxx
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
 bjajs,pcajs,yzajs,hgajs,xcajs,bhgajs,
 to_char(decode(y.bjajs,0,0,y.pcajs*100/y.bjajs),'fm999999990.0099')||'%' pczb,
 to_char(decode(y.pcajs,0,0,y.yzajs*100/y.pcajs),'fm999999990.0099')||'%' yzajzb,
 to_char(decode(y.pcajs,0,0,y.hgajs*100/y.pcajs),'fm999999990.0099')||'%' hgajzb,
 to_char(decode(y.pcajs,0,0,y.xcajs*100/y.pcajs),'fm999999990.0099')||'%' xcajzb,
 to_char(decode(y.pcajs,0,0,y.bhgajs*100/y.pcajs),'fm999999990.0099')||'%' bhgajzb,
 sfhj
 FROM 
  (
  SELECT ywtx,ajlb_bm,bjajs,pcajs,yzajs,hgajs,xcajs,bhgajs,sfhj from hztab 
  UNION ALL
  --���Ӻϼ���
  SELECT nvl(ywtx,'-1') ywtx,'-1',sum(bjajs),sum(pcajs),sum(yzajs),sum(hgajs),sum(xcajs),sum(bhgajs),'Y' sfhj 
       FROM hztab  GROUP BY ROLLUP (ywtx)  
  ) y
/*RIGHT*/INNER JOIN txtab x ON x.ywtx=y.ywtx AND x.ajlb_bm=y.ajlb_bm
  WHERE y.pcajs >0 --ֻ��ʾ����������0��
  ORDER by x.ywtx,x.ajlb_bm   
--�������end
 
