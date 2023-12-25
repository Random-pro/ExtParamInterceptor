package com.live.domian;

import lombok.Data;

import java.util.List;

/**
 * @author sun
 */
@Data
public class Base extends BaseDomain {
    private int id;
    private String baseName;
    private String basePath;
    private List<Child> pathChildList;
}