package com.live.domian;

import lombok.Data;

import java.util.Date;

/**
 * @author sun
 * 公共参数Domain 当需要在Mybatis映射的实体中拿到如下参数，只需要实体继承该BaseDomain即可 完全不需要做任何其他配置 具体使用方法请参考TestMapper中的相关方法
 */
@Data
public class BaseDomain {
    private String createBy;
    private Date createTime;
    private String updateBy;
    private Date updateTime;
}
