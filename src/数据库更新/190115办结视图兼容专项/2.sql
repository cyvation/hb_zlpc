CREATE OR REPLACE VIEW V_PCAJXX AS
  SELECT
    PCSLBM,
    PCSAH,
    PCDWBM,
    ju.PCFLBM,
    PCHDBM,
    BMSAH,
    TYSAH,
    AJMC,
    ju.AJLB_BM,
    ju.AJLB_MC,
    BPC_DWBM,
    BPC_DWMC,
    BPC_BMBM,
    BPC_BMMC,
    BPC_GH,
    BPC_MC,
    BPC_SLRQ,
    BPC_WCRQ,
    LCSLBH,
    PCJDBH,
    PCJDMS,
    SXR_DWBM,
    SXR_GH,
    FPDZ_FPR_DWBM,
    FPDZ_FPR_GH,
    FPDR_FPR_DWBM,
    FPDR_FPR_DWMC,
    FPDR_FPR_GH,
    FPDR_FPR_MC,
    PCZ_BM,
    PCZ_MC,
    PCR_DWBM,
    PCR_DWMC,
    PCR_GH,
    PCR_MC,
    ju.PCMBBM,
    AJGLZT,
    PCJG,
    PCJL,
    PCBGBH,
    ju.SM,
    ju.cjsj,
    ZHXGSJ,
    SXGZBM,
    nvl(gz.fgzbm,'-1') fgzbm,
    SXR_DWMC,
    SXR_MC,
    FPDZ_FPR_DWMC,
    FPDZ_FPR_MC,
    WAY,
    WCRQ_NF,
    mu.ywtx,
    mu.pcmbmc ywtx_mc,
    nvl(ju.sfldba,'N') sfldba,
    nvl(st.stajbs,'0') stajbs
  from yx_pc_jbxx ju LEFT JOIN xt_pc_mb mu ON   ju.pcmbbm=mu.pcmbbm
    LEFT JOIN xt_dm_stajbs st ON ju.ajlb_bm=st.ajlb_bm
    left join xt_pc_sxgz gz on ju.sxgzbm = gz.gzbm
  WHERE ju.sfsc='N'
        AND ju.pcjdbh='011'
--AND to_char(nvl(ju.bpc_wcrq,ju.bpc_wcbzrq),'yyyy')>='2013'

/*
    UNION  ALL

    SELECT
      PCSLBM,
      PCSAH,
      PCDWBM,
      jv.PCFLBM,
      PCHDBM,
      BMSAH,
      TYSAH,
      AJMC,
      jv.AJLB_BM,
      jv.AJLB_MC,
      BPC_DWBM,
      BPC_DWMC,
      BPC_BMBM,
      BPC_BMMC,
      BPC_GH,
      BPC_MC,
      BPC_SLRQ,
      BPC_WCRQ,
      LCSLBH,
      PCJDBH,
      PCJDMS,
      SXR_DWBM,
      SXR_GH,
      FPDZ_FPR_DWBM,
      FPDZ_FPR_GH,
      FPDR_FPR_DWBM,
      FPDR_FPR_DWMC,
      FPDR_FPR_GH,
      FPDR_FPR_MC,
      PCZ_BM,
      PCZ_MC,
      PCR_DWBM,
      PCR_DWMC,
      PCR_GH,
      PCR_MC,
      jv.PCMBBM,
      AJGLZT,
      PCJG,
      PCJL,
      PCBGBH,
      jv.SM,
      jv.cjsj,
      ZHXGSJ,
      SXGZBM,
      nvl(gz.fgzbm,'-1') fgzbm,
      SXR_DWMC,
      SXR_MC,
      FPDZ_FPR_DWMC,
      FPDZ_FPR_MC,
      WAY,
      WCRQ_NF,
      mv.ywtx,
      mv.pcmbmc ywtx_mc,
      nvl(jv.sfldba,'N') sfldba,
      nvl(st.stajbs,'0') stajbs
    from
      yx_pc_offline_jbxx jv LEFT JOIN xt_pc_mb mv ON   jv.pcmbbm=mv.pcmbbm
      LEFT JOIN xt_dm_stajbs st ON jv.ajlb_bm=st.ajlb_bm
      left join xt_pc_sxgz gz on jv.sxgzbm = gz.gzbm
    WHERE  jv.wcrq_nf>='2013' --AND jv.wcrq_nf<'2018'
    AND jv.sfsc='N'
    */;
