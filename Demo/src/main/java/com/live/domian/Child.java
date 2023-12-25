package com.live.domian;

import lombok.Data;

@Data
public class Child extends BaseDomain {
    private int childId;
    private int parentId;
    private String childName;
    private String path;
}