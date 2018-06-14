--���°�᰸����
TRUNCATE TABLE tyyw_bjaj;

--������ڿ���Ϊ�գ�����ɱ�־����
UPDATE yx_pc_jbxx j SET j.bpc_wcrq=(SELECT MAX(wcrq) FROM tyyw_gg_ajjbxx@tyyw_link.net) WHERE j.bpc_wcrq IS NULL;
UPDATE yx_pc_jbxx j SET j.bpc_wcrq=j.bpc_wcbzrq WHERE j.bpc_wcrq IS NULL;
UPDATE yx_pc_jbxx j SET j.wcrq_nf=to_char(nvl(j.bpc_wcrq,bpc_wcbzrq),'yyyy') WHERE j.bpc_wcrq IS NULL;

--�����鰸������ȡ
INSERT INTO tyyw_bjaj 
(pcflbm,bmsah,tysah,ajmc,ajlb_bm,ajlb_mc,cb_dwbm,cb_dwmc,cb_bmbm,cb_bmmc,cbrgh,cbr,slrq,wcrq,way,sfldba,wcrq_nf,YWTX)
SELECT 
  j.pcflbm,bmsah,tysah,ajmc,ajlb_bm,ajlb_mc,j.bpc_dwbm,bpc_dwmc,bpc_bmbm,bpc_bmmc,j.bpc_gh,bpc_mc,bpc_slrq,bpc_wcrq,way,'N' sfldba,wcrq_nf,m.YWTX
 FROM yx_pc_jbxx j
 INNER JOIN xt_pc_mb m ON j.pcmbbm=m.pcmbbm
  WHERE    
    NOT EXISTS (
     SELECT b.bmsah from tyyw_bjaj b WHERE b.bmsah=j.bmsah
    ) 
   AND j.sfsc='N'
   AND  j.wcrq_nf<'2018';
   
--ɸѡ��¼��ѯ�ظ��� 
select count(*), t.pcflbm,t.bmsah,t.ywtx from yx_pc_sxjl t
group by t.pcflbm,t.bmsah,t.ywtx
having count(*)>1;  
   
--ɸѡ��¼������ȥ��
/*DELETE  FROM yx_pc_sxjl E 
 WHERE E.ROWID > (SELECT MIN(X.ROWID)  FROM yx_pc_sxjl X WHERE X.bmsah = E.bmsah AND x.ywtx=e.ywtx AND x.pcflbm=e.pcflbm \*AND x.ajlb_bm=e.ajlb_bm*\)   
*/


--�����м��,Ȼ��ɾ��rn�ֶΣ�
 create table yx_pc_sxjl_distinct as 
   select a.* from 
     (select o.*,
              row_number() over(partition by bmsah,pcflbm, ywtx ORDER  by o.bmsah) rn
            from yx_pc_sxjl o) a
   where a.rn =1; 
 
--Ȼ�� ��ɸѡ��¼��ȡ 
INSERT INTO tyyw_bjaj 
(pcflbm,bmsah,tysah,ajmc,ajlb_bm,ajlb_mc,cb_dwbm,cb_dwmc,cb_bmbm,cb_bmmc,cbrgh,cbr,slrq,wcrq,way,sfldba,wcrq_nf,ywtx)
SELECT s.pcflbm,s.bmsah,s.tysah,s.ajmc,s.ajlb_bm,s.ajlb_mc,s.dwbm ,s.dwmc ,s.bmbm,s.bmmc ,s.cbrgh,s.cbrmc,s.slrq,s.wcrq,'0','N',to_char(s.wcrq,'yyyy'),s.ywtx
  FROM yx_pc_sxjl_distinct s 
  WHERE NOT EXISTS (
     SELECT b.bmsah from tyyw_bjaj b WHERE b.bmsah=s.bmsah AND b.pcflbm=s.pcflbm
    ) 
    AND s.wcrq_nf<'2018'
    ;
