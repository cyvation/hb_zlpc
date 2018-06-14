--�������ߵ���������������ࣩ
SELECT *
  FROM TYYW_GG_AJJBXX AJ
 INNER JOIN TYYW_ZJ_FZXYR T ON AJ.BMSAH = T.BMSAH
                           AND AJ.CBDW_BM = T.CBDW_BM
 INNER JOIN YX_AG_GLAJ GL ON T.BMSAH = GL.YAJ_BMSAH
                         AND GL.SFSC = 'N'
                         AND GL.YAJ_AJLB_BM = '0201'
 INNER JOIN (SELECT *
               FROM TYYW_GS_XYRQK
              WHERE SJCLQK_DM LIKE '0322110102%') GS ON GS.BMSAH =
                                                        GL.GLAJ_BMSAH
                                                    AND GS.XYRBH = T.XYRBH
                                                    AND GS.SFSC = 'N'
 WHERE T.SFSC = 'N'
   AND T.SJRQ IS NOT NULL
   AND T.SJCLJG_DM LIKE '0201101201%'
   AND AJ.SFSC = 'N'
   AND EXISTS (SELECT 1
          FROM TYYW_GG_XYRJBXX XYR
         WHERE XYR.SFSC = 'N'
           AND AJ.BMSAH = XYR.BMSAH
           AND T.XYRBH = XYR.XYRBH
           AND XYR.ZASNL >= '18');

--�������ߵ�������������δ�죩
SELECT *
  FROM TYYW_GG_AJJBXX AJ
 INNER JOIN TYYW_ZJ_FZXYR T ON AJ.BMSAH = T.BMSAH
                           AND AJ.CBDW_BM = T.CBDW_BM
 INNER JOIN YX_AG_GLAJ GL ON T.BMSAH = GL.YAJ_BMSAH
                         AND GL.SFSC = 'N'
                         AND GL.YAJ_AJLB_BM = '0201'
 INNER JOIN (SELECT *
               FROM TYYW_GS_XYRQK
              WHERE SJCLQK_DM LIKE '0322110102%') GS ON GS.BMSAH =
                                                        GL.GLAJ_BMSAH
                                                    AND GS.XYRBH = T.XYRBH
                                                    AND GS.SFSC = 'N'
 WHERE T.SFSC = 'N'
   AND T.SJRQ IS NOT NULL
   AND T.SJCLJG_DM LIKE '0201101201%'
   AND AJ.SFSC = 'N'
   AND EXISTS (SELECT 1
          FROM TYYW_GG_XYRJBXX XYR
         WHERE XYR.SFSC = 'N'
           AND AJ.BMSAH = XYR.BMSAH
           AND T.XYRBH = XYR.XYRBH
           AND XYR.ZASNL < '18'
           AND XYR.ZASNL > '0');

--���󳷰�����������������ࣩ
SELECT COUNT(1)
  FROM TYYW_GG_AJJBXX AJ
 INNER JOIN TYYW_ZJ_FZXYR T ON AJ.BMSAH = T.BMSAH
                           AND T.SFSC = 'N'
                           AND AJ.CBDW_BM = T.CBDW_BM
 WHERE T.SFSC = 'N'
   AND T.SJRQ IS NOT NULL
   AND T.SJCLJG_DM LIKE '0201101201%'
   AND AJ.SFSC = 'N'
   AND T.BHCARQ IS NOT NULL
   AND EXISTS (SELECT 1
          FROM TYYW_GG_XYRJBXX XYR
         WHERE XYR.SFSC = 'N'
           AND AJ.BMSAH = XYR.BMSAH
           AND T.XYRBH = XYR.XYRBH
           AND XYR.ZASNL >= '18');
--���󳷰���������������δ�죩
SELECT COUNT(1)
  FROM TYYW_GG_AJJBXX AJ
 INNER JOIN TYYW_ZJ_FZXYR T ON AJ.BMSAH = T.BMSAH
                           AND T.SFSC = 'N'
                           AND AJ.CBDW_BM = T.CBDW_BM
 WHERE T.SFSC = 'N'
   AND T.SJRQ IS NOT NULL
   AND T.SJCLJG_DM LIKE '0201101201%'
   AND AJ.SFSC = 'N'
   AND T.BHCARQ IS NOT NULL
   AND EXISTS (SELECT 1
          FROM TYYW_GG_XYRJBXX XYR
         WHERE XYR.SFSC = 'N'
           AND AJ.BMSAH = XYR.BMSAH
           AND T.XYRBH = XYR.XYRBH
           AND XYR.ZASNL < '18'
           AND XYR.ZASNL > '0');

--�������������������������ࣩ
SELECT COUNT(1)
  FROM TYYW_GG_AJJBXX AJ
 INNER JOIN TYYW_ZJ_FZXYR T ON AJ.BMSAH = T.BMSAH
                           AND T.SFSC = 'N'
                           AND AJ.CBDW_BM = T.CBDW_BM
 INNER JOIN YX_AG_GLAJ GL ON T.BMSAH = GL.YAJ_BMSAH
                         AND GL.SFSC = 'N'
                         AND GL.YAJ_AJLB_BM = '0201'
 INNER JOIN (SELECT *
               FROM TYYW_GS_XYRQK
              WHERE YSPJZM_AYDM LIKE '03333344008%') GS ON GS.BMSAH =
                                                           GL.GLAJ_BMSAH
                                                       AND GS.SFSC = 'N'
                                                       AND GS.XYRBH = T.XYRBH
 WHERE T.SFSC = 'N'
   AND T.SJRQ IS NOT NULL
   AND T.SJCLJG_DM LIKE '0201101201%'
   AND AJ.SFSC = 'N'
   AND EXISTS (SELECT 1
          FROM TYYW_GG_XYRJBXX XYR
         WHERE XYR.SFSC = 'N'
           AND AJ.BMSAH = XYR.BMSAH
           AND T.XYRBH = XYR.XYRBH
           AND XYR.ZASNL >= '18');

--�����������������������δ�죩
SELECT COUNT(1)
  FROM TYYW_GG_AJJBXX AJ
 INNER JOIN TYYW_ZJ_FZXYR T ON AJ.BMSAH = T.BMSAH
                           AND T.SFSC = 'N'
                           AND AJ.CBDW_BM = T.CBDW_BM
 INNER JOIN YX_AG_GLAJ GL ON T.BMSAH = GL.YAJ_BMSAH
                         AND GL.SFSC = 'N'
                         AND GL.YAJ_AJLB_BM = '0201'
 INNER JOIN (SELECT *
               FROM TYYW_GS_XYRQK
              WHERE YSPJZM_AYDM LIKE '03333344008%') GS ON GS.BMSAH =
                                                           GL.GLAJ_BMSAH
                                                       AND GS.SFSC = 'N'
                                                       AND GS.XYRBH = T.XYRBH
 WHERE T.SFSC = 'N'
   AND T.SJRQ IS NOT NULL
   AND T.SJCLJG_DM LIKE '0201101201%'
   AND AJ.SFSC = 'N'
   AND EXISTS (SELECT 1
          FROM TYYW_GG_XYRJBXX XYR
         WHERE XYR.SFSC = 'N'
           AND AJ.BMSAH = XYR.BMSAH
           AND T.XYRBH = XYR.XYRBH
           AND XYR.ZASNL < '18'
           AND XYR.ZASNL > '0');
-----------------416--------------------------
--������(����)

SELECT aj.cbdw_bm DWBM,
       aj.bmsah   BMSAH,
       aj.wcrq    WCBZRQ
  FROM TYYW_GG_AJJBXX AJ
 INNER JOIN TYYW_GS_XYRQK T ON AJ.BMSAH = T.BMSAH
                           AND T.SFSC = 'N'
                           AND AJ.CBDW_BM = T.CBDW_BM
 WHERE SJCLQK_DM BETWEEN '0322110102000' AND '0322110102032'
   AND AJ.SFSC = 'N'
   AND aj.wcrq IS NOT NULL
   AND AJ.AJLB_BM = '0301';

--���Բ���(����)
SELECT COUNT(1)
  FROM TYYW_GG_AJJBXX AJ
 INNER JOIN TYYW_GS_XYRQK T ON AJ.BMSAH = T.BMSAH
                           AND T.SFSC = 'N'
                           AND AJ.CBDW_BM = T.CBDW_BM
 WHERE SJCLQK_DM BETWEEN '0322110102000' AND '0322110102012'
   AND AJ.SFSC = 'N'
   AND AJ.AJLB_BM = '0301';

--���Բ�����(����)
SELECT COUNT(1)
  FROM TYYW_GG_AJJBXX AJ
 WHERE AJ.SFSC = 'N'
   AND AJ.AJLB_BM = '0301'
   AND EXISTS
 (SELECT 1
          FROM TYYW_GS_XYRQK T
         WHERE T.sfsc = 'N'
           AND AJ.BMSAH = T.BMSAH
           AND SJCLQK_DM BETWEEN '0322110102010' AND '0322110102012')
--��Բ�����(����)
  SELECT COUNT(1)
          FROM TYYW_GG_AJJBXX AJ
         WHERE AJ.SFSC = 'N'
           AND AJ.AJLB_BM = '0301'
           AND EXISTS
         (SELECT 1
                  FROM TYYW_GS_XYRQK T
                 WHERE T.sfsc = 'N'
                   AND AJ.BMSAH = T.BMSAH
                   AND SJCLQK_DM BETWEEN '0322110102020' AND '0322110102022')
        
        --���Բ���(δ��)
          SELECT COUNT(1)
                  FROM TYYW_GG_AJJBXX AJ
                 INNER JOIN TYYW_GS_XYRQK T ON AJ.BMSAH = T.BMSAH
                                           AND T.SFSC = 'N'
                                           AND AJ.CBDW_BM = T.CBDW_BM
                 WHERE SJCLQK_DM BETWEEN '0322110102010' AND '0322110102012'
                   AND AJ.SFSC = 'N'
                   AND AJ.AJLB_BM = '0314';



--���Բ�����(δ��)
SELECT COUNT(1)
  FROM TYYW_GG_AJJBXX AJ
 WHERE AJ.SFSC = 'N'
   AND AJ.AJLB_BM = '0314'
   AND EXISTS
 (SELECT 1
          FROM TYYW_GS_XYRQK T
         WHERE T.sfsc = 'N'
           AND AJ.BMSAH = T.BMSAH
           AND SJCLQK_DM BETWEEN '0322110102010' AND '0322110102012')
--��Բ�����(δ��)
  SELECT COUNT(1)
          FROM TYYW_GG_AJJBXX AJ
         WHERE AJ.SFSC = 'N'
           AND AJ.AJLB_BM = '0314'
           AND EXISTS
         (SELECT 1
                  FROM TYYW_GS_XYRQK T
                 WHERE T.sfsc = 'N'
                   AND AJ.BMSAH = T.BMSAH
                   AND SJCLQK_DM BETWEEN '0322110102020' AND '0322110102022');


-- ���ߺ󳷻ص�һ���߰��������ߣ�
SELECT *
  FROM TYYW_GG_AJJBXX AJ
 INNER JOIN TYYW_GS_XYRQK T ON AJ.BMSAH = T.BMSAH
                           AND T.SfSC = 'N'
                           AND AJ.CBDW_BM = T.CBDW_BM
 WHERE SJCLQK_DM = '0322110101000'
   AND CHQSRQ IS NOT NULL
   AND AJ.SFSC = 'N'
   AND AJ.AJLB_BM = '0301';

-- ���ߺ󳷻ص�һ���߰�����δ�죩
SELECT *
  FROM TYYW_GG_AJJBXX AJ
 INNER JOIN TYYW_GS_XYRQK T ON AJ.BMSAH = T.BMSAH
                           AND T.SfSC = 'N'
                           AND AJ.CBDW_BM = T.CBDW_BM
 WHERE SJCLQK_DM = '0322110101000'
   AND CHQSRQ IS NOT NULL
   AND AJ.SFSC = 'N'
   AND AJ.AJLB_BM = '0314';
-----------++++++++++++++++++++++++++++++++++++++++++++++++++--------------
--���ߺ󳷻ؿ��ߵĶ����߻������мල���߰��������мල��
SELECT *
  FROM TYYW_GG_AJJBXX AJ
 WHERE EXISTS (SELECT 1
          FROM TYYW_GS_ESKS T
         WHERE T.SFSC = 'N'
           AND AJ.BMSAH = T.BMSAH
           AND CHKSRQ IS NOT NULL)
   AND AJ.SFSC = 'N'
   AND aj.wcrq IS NOT NULL
   AND AJ.AJLB_BM = '0304'
UNION ALL
SELECT *
  FROM TYYW_GG_AJJBXX AJ
 WHERE EXISTS (SELECT 1
          FROM TYYW_GS_SPJDCXKS T
         WHERE T.sfsc = 'N'
           AND AJ.BMSAH = T.BMSAH
           AND bychksrq IS NOT NULL)
   AND AJ.SFSC = 'N'
   AND aj.wcrq IS NOT NULL
   AND AJ.AJLB_BM = '0305';

--��������ش���������������߰��������꣩
SELECT *
  FROM TYYW_GG_AJJBXX AJ
 WHERE AJ.SFSC = 'N'
   AND EXISTS
   (SELECT 1
          FROM TYYW_SS_XSSSFC T
         WHERE T.SFSC = 'N'
           AND AJ.BMSAH = T.BMSAH
           AND (T.SSLB_DM BETWEEN '0930136301000' AND '0930136301006')
           AND T.LAFCJG_DM IN ('0916132402000', '0916132403000')
   )
   AND aj.wcrq IS NOT NULL
   AND AJ.AJLB_BM = '0901';

--���������⳥�Ĺ����⳥���������꣩
SELECT *
  FROM TYYW_GG_AJJBXX AJ
 WHERE AJ.SFSC = 'N'  
   AND EXISTS (SELECT 1
          FROM tyyw_ss_xspc T
         WHERE T.SFSC = 'N'
           AND AJ.BMSAH = T.BMSAH
           AND INSTR(JDQK_DMS,'0903133701000') > 0)
   AND aj.wcrq IS NOT NULL
   AND AJ.AJLB_BM = '0904';

--������֧�ּල����������������ϲ��н���ල���������У�
   SELECT *
          FROM TYYW_GG_AJJBXX AJ
         WHERE AJ.SFSC = 'N'
           AND EXISTS
         (SELECT 1
                  FROM TYYW_MX_MSXZJD T
                 WHERE T.SFSC = 'N'
                   AND AJ.BMSAH = T.BMSAH
                   AND (T.AJXZ_DM BETWEEN '0702500000000' AND '0702512000000')
                   AND T.JACLQK_DM IN ('0704220100004', '0704220100005')
         )
         AND aj.wcrq IS NOT NULL
         AND AJ.AJLB_BM = '0701'
         ;
----418-���ߺ�������---------------------------------
 --����
SELECT *
  FROM TYYW_GG_AJJBXX AJ
 WHERE AJ.SFSC = 'N'
   AND EXISTS
 (SELECT 1
          FROM TYYW_GS_XYRQK T
         WHERE T.SFSC = 'N'
           AND AJ.BMSAH = T.BMSAH
           AND T. YSXGX_DM BETWEEN '0333334400800' AND '0333334400802'
           AND T.SXPJRQ IS NOT NULL)
   AND aj.wcrq IS NOT NULL
   AND AJ.AJLB_BM = '0301'           ;
          
 --δ��
 SELECT *
  FROM TYYW_GG_AJJBXX AJ
 WHERE AJ.SFSC = 'N'
   AND AJ.AJLB_BM = '0314'
   AND EXISTS
 (SELECT 1
          FROM TYYW_GS_XYRQK T
         WHERE T.SFSC = 'N'
           AND AJ.BMSAH = T.BMSAH
           AND T.YSXGX_DM BETWEEN '0333334400800' AND '0333334400802'
           AND T.SXPJRQ IS NOT NULL)  ;

--������ ���
 SELECT *
  FROM TYYW_GG_AJJBXX AJ
 WHERE AJ.SFSC = 'N'
   AND AJ.AJLB_BM = '0304'
   AND EXISTS
 (SELECT 1
          FROM TYYW_GS_XYRQK T
         WHERE T.SFSC = 'N'
           AND AJ.BMSAH = T.BMSAH
           AND T.ESXGX_DM BETWEEN '0333334400800' AND '0333334400802')   ; 
 ����
���ߺ�������ľ���������
