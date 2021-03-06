package com.start.boot.domain;

import com.start.boot.common.Param_Pager;

/**
 * Created by lei on 2017/11/10.
 */
public class Param_Pcjk extends Param_Pager {

    //单位编码
    private String dwbm;

    //承办单位
    private String cbdwbm;

    //部门编码
    private String bmbm;
    //工号
    private String gh;
    //评查单位编码
    private String pcdwbm;
    //评查分类编码
    private String pcflbm;
    //评查员
    private String pcy;
    //承办人
    private String cbr;
    //评查结论
    private String pcjl;
    //评查状态
    private String pczt;
    //评查开始时间
    private String wcrqbng;
    //评查结束时间
    private String wcrqend;
    // 案件办结开始时间
    private String bjrqbng;
    // 案件办结结束时间
    private String bjrqend;
    //类型
    private String type;
    //案件名称
    private  String ajmc;
    //部门受案号
    private  String bmsah;
    //筛选规则编码
    private  String sxgzbm;

    //业务条线
    private  String ywtx;

    //承办人身份
    private  String cbrsf;

    //评查项编码
    private  String pcxbm;

    public String getDwbm() {
        return dwbm;
    }

    public void setDwbm(String dwbm) {
        this.dwbm = dwbm;
    }

    public String getBmbm() {
        return bmbm;
    }

    public void setBmbm(String bmbm) {
        this.bmbm = bmbm;
    }

    public String getGh() {
        return gh;
    }

    public void setGh(String gh) {
        this.gh = gh;
    }

    public String getPcdwbm() {
        return pcdwbm;
    }

    public void setPcdwbm(String pcdwbm) {
        this.pcdwbm = pcdwbm;
    }

    public String getPcflbm() {
        return pcflbm;
    }

    public void setPcflbm(String pcflbm) {
        this.pcflbm = pcflbm;
    }

    public String getPcy() {
        return pcy;
    }

    public void setPcy(String pcy) {
        this.pcy = pcy;
    }

    public String getCbr() {
        return cbr;
    }

    public void setCbr(String cbr) {
        this.cbr = cbr;
    }

    public String getPcjl() {
        return pcjl;
    }

    public void setPcjl(String pcjl) {
        this.pcjl = pcjl;
    }

    public String getPczt() {
        return pczt;
    }

    public void setPczt(String pczt) {
        this.pczt = pczt;
    }

    public String getWcrqbng() {
        return wcrqbng;
    }

    public void setWcrqbng(String wcrqbng) {
        this.wcrqbng = wcrqbng;
    }

    public String getWcrqend() {
        return wcrqend;
    }

    public void setWcrqend(String wcrqend) {
        this.wcrqend = wcrqend;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getAjmc() { return ajmc; }

    public void setAjmc(String ajmc) { this.ajmc = ajmc; }

    public String getSxgzbm() {
        return sxgzbm;
    }

    public void setSxgzbm(String sxgzbm) {
        this.sxgzbm = sxgzbm;
    }


    public String getCbdwbm() {
        return cbdwbm;
    }

    public void setCbdwbm(String cbdwbm) {
        this.cbdwbm = cbdwbm;
    }

    public String getBjrqbng() {
        return bjrqbng;
    }

    public void setBjrqbng(String bjrqbng) {
        this.bjrqbng = bjrqbng;
    }

    public String getBjrqend() {
        return bjrqend;
    }

    public void setBjrqend(String bjrqend) {
        this.bjrqend = bjrqend;
    }

    public String getYwtx() {
        return ywtx;
    }

    public void setYwtx(String ywtx) {
        this.ywtx = ywtx;
    }

    public String getPcxbm() {
        return pcxbm;
    }

    public void setPcxbm(String pcxbm) {
        this.pcxbm = pcxbm;
    }

    public String getBmsah() {
        return bmsah;
    }

    public void setBmsah(String bmsah) {
        this.bmsah = bmsah;
    }

    public String getCbrsf() {
        return cbrsf;
    }

    public void setCbrsf(String cbrsf) {
        this.cbrsf = cbrsf;
    }
}
