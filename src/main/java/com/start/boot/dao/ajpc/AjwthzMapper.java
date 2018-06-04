package com.start.boot.dao.ajpc;

import java.util.List;
import com.start.boot.pojo.vo.AjpcwtxVo;
import com.start.boot.query.QueryTable;
import org.springframework.stereotype.Repository;

@Repository
public interface AjwthzMapper {

    List<AjpcwtxVo> getAjwthzList(QueryTable query) throws Exception;

    List<AjpcwtxVo> getOfflineAjwthzList(QueryTable query) throws Exception;

    List<AjpcwtxVo> getBarAjwthzList(QueryTable query) throws Exception;

    List<AjpcwtxVo> getOfflineBarAjwthzList(QueryTable query) throws Exception;
}
