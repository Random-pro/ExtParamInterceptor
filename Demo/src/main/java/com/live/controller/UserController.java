package com.live.controller;

import com.live.domian.Base;
import com.live.domian.Child;
import com.live.mapper.TestMapper;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.sql.DataSource;

import java.util.List;

/**
 * @author sun
 */
@RestController
@RequestMapping("user")
public record UserController(DataSource dataSource, TestMapper testMapper) {

    @RequestMapping("/get")
    public String getUser() {
        return "ok";
    }

    @GetMapping("findByState")
    public void findByState() {
        testMapper.findByState("6");
    }

    @GetMapping("updateVal")
    public void updateVal(String id, String value) {
        testMapper.updateVal(id, value);
    }

    @GetMapping("getPathList")
    public List<Base> getPathList() {
        return testMapper.getPathList();
    }

    @GetMapping("getChildList")
    public List<Child> getChildList() {
        return testMapper.getChildList();
    }

    @GetMapping("insertVal")
    public int insertVal(String id, String value) {
        return testMapper.insertVal(id, value);
    }

    @GetMapping("findA")
    public List<String> findA() {
        return testMapper.findA();
    }

    @GetMapping("getBaseAndChildPath")
    public List<Base> getBaseAndChildPath() {
        return testMapper.getBaseAndChildPath();
    }
}
