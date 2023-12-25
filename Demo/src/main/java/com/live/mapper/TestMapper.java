package com.live.mapper;

import com.live.domian.Base;
import com.live.domian.Child;
import org.apache.ibatis.annotations.*;

import java.util.List;

/**
 * @author sun
 */
@Mapper
public interface TestMapper {
    @Select("SELECT value FROM a WHERE id = #{state}")
    String findByState(@Param("state") String state);

    @Select("SELECT value FROM A")
    List<String> findA();

    @Update("UPDATE a set value = #{value} where id = #{id}")
    int updateVal(@Param("id") String id, @Param("value") String value);

    @Insert("INSERT INTO a(ID, VALUE) VALUES(#{id}, #{value})")
    int insertVal(@Param("id") String id, @Param("value") String value);

    List<Base> getPathList();

    @Select("SELECT id as childId, name as childName, parent_id as parentId, path FROM child")
    List<Child> getChildList();

    @Select("SELECT BASE.ID as id , BASE.BASE_NAME as baseName, CHILD.PATH as basePath FROM BASE, CHILD WHERE BASE.ID = CHILD.PARENT_ID")
    List<Base> getBaseAndChildPath();
}
