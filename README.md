# ExtParamInterceptor
单文件的小巧Mybatis插件 无侵入实现增删改查操作自动添加&amp;映射公共参数

---

## 使用方法：
1. 将仓库下的MyBatisParamExecutorInterceptorV2.java放置于能被SpringBoot扫描到的工程目录下（如果自身项目配置了Mybatis的SpringBoot Starter，则无需做额外处理，否则需要手动将该插件加入到Mbatis配置文件）
2. 添加插件依赖（如果项目本身使用了MybatisPlus，由于其本身依赖中包含了JSqlParser则通常无需再添加）：
~~~xml
<dependency>
  <groupId>com.github.jsqlparser</groupId>
  <artifactId>jsqlparser</artifactId>
  <version>4.6</version>
  <scope>compile</scope>
</dependency>
~~~
3. 修改文件中的如下配置
~~~java
    /**
     * 如下为映射字段与实体名的相关配置 如有不同之处可自行修改：
     * XXX_PROPERTY - 为实体类对应字段   XXX_COLUMN - 为数据库中对应列名
     * 目前仅支持创建人 更新人 创建时间 更新时间四个字段的添加 后续会变为动态可配置的方式
     */
    private static final String CREATE_BY_PROPERTY = "createBy";
    private static final String CREATE_BY_COLUMN = "create_by";
    private static final String UPDATE_BY_PROPERTY = "updateBy";
    private static final String UPDATE_BY_COLUMN = "update_by";
    private static final String CREATE_TIME_PROPERTY = "createTime";
    private static final String CREATE_TIME_COLUMN = "create_time";
    private static final String UPDATE_TIME_PROPERTY = "updateTime";
    private static final String UPDATE_TIME_COLUMN = "update_time";

    // 这里需自行实现获取当前用户的逻辑
    private static String getCurrentUser() {
        return "RANDOM-PRO";
    }
~~~
> 之后使用Mybatis进行的所有增删改查操作都会被自动添加创建人、创建时间、修改人、修改时间

> 注意：该插件适配JDK17、SpringBoot3.0+版本，较旧的版本可能存在不兼容的情况。仓库目录下Demo为插件使用的示例工程，可作为参考

## 工作方式
1. Insert操作：自动为Insert语句添加创建人、创建时间字段并赋值
2. Update操作：自动为Update语句添加修改人、修改时间字段并赋值
3. Select操作：当被映射实体类中包含如上配置中定义的四个实体名
- **CREATE_BY_PROPERTY**
- **UPDATE_BY_PROPERTY**
- **CREATE_TIME_PROPERTY**
- **UPDATE_TIME_PROPERTY**

  其一时，则自动为该实体添加字段到属性的映射绑定，查询时会自动带出四个字段的值。

  > 其中的映射规则为：每张表的字段/每个查询的列对应一个实体中的属性值

### 常见查询示例：
1. 单表查询
    ~~~java
    // 实体类Child(类名对应具体的表名 使用驼峰命名法，如表名为user_role,则类名应写为UserRole)
    @Data
    public class Child extends BaseDomain {
      private int childId;
      private int parentId;
      private String childName;
      private String path;
    }

    // 公共字段
    @Data
    public class BaseDomain {
      private String createBy;
      private Date createTime;
      private String updateBy;
      private Date updateTime;
    }

    // Mapper接口
    @Mapper
    public interface TestMapper {
      @Select("SELECT id as childId, name as childName, parent_id as parentId, path FROM child")
      List<Child> getChildList();
    }

    // Controller
    @RestController
    @RequestMapping("user")
    public record UserController(TestMapper testMapper) {
      @GetMapping("getChildList")
      public List<Child> getChildList() {
        return testMapper.getChildList();
      }
    }
    ~~~

   访问user/getChildList获取结果：

    ~~~json
    [
        {
            "createBy": "sun11",
            "createTime": "2023-12-18T07:58:58.000+00:00",
            "updateBy": "random",
            "updateTime": "2023-12-18T07:59:19.000+00:00",
            "childId": 1,
            "parentId": 1,
            "childName": "childName1_1",
            "path": "childPath1_1"
        },
        {
            "createBy": "sun12",
            "createTime": "2023-12-18T07:58:59.000+00:00",
            "updateBy": "RANDOM",
            "updateTime": "2023-12-18T07:59:20.000+00:00",
            "childId": 2,
            "parentId": 1,
            "childName": "childName1_2",
            "path": "childPath1_2"
        },
        {
            "createBy": "sun21",
            "createTime": "2023-12-18T07:59:00.000+00:00",
            "updateBy": "randompro",
            "updateTime": "2023-12-18T07:59:21.000+00:00",
            "childId": 3,
            "parentId": 2,
            "childName": "childName2_1",
            "path": "childPath2_2"
        }
    ]
    ~~~

2. 多表查询
    ~~~java
    // 实体类Base(类名对应具体的表名 使用驼峰命名法，如表名为user_role,则类名应写为UserRole) 注意：当关联多个表时，需要取哪个表里的公共字段（创建人、创建时间等字段）则将映射实体类名命名为该表的表名
    @Data
    public class Base extends BaseDomain {
      private int id;
      private String baseName;
      private String basePath;
      private List<Child> pathChildList;
    }

    @Data
    public class Child extends BaseDomain {
      private int childId;
      private int parentId;
      private String childName;
      private String path;
    }

    // 公共字段
    @Data
    public class BaseDomain {
      private String createBy;
      private Date createTime;
      private String updateBy;
      private Date updateTime;
    }

    // Mapper接口
    @Mapper
    public interface TestMapper {
      @Select("SELECT BASE.ID as id , BASE.BASE_NAME as baseName, CHILD.PATH as basePath FROM BASE, CHILD WHERE BASE.ID = CHILD.PARENT_ID")
      List<Base> getBaseAndChildPath();
    }

    // Controller
    @RestController
    @RequestMapping("user")
    public record UserController(TestMapper testMapper) {
      @GetMapping("getBaseAndChildPath")
      public List<Base> getBaseAndChildPath() {
        return testMapper.getBaseAndChildPath();
      }
    }
    ~~~

   访问user/getBaseAndChildPath获取结果：

    ~~~json
    [
        {
            "createBy": "sun_base",
            "createTime": "2023-12-18T07:59:29.000+00:00",
            "updateBy": "random_base",
            "updateTime": "2023-12-18T08:00:09.000+00:00",
            "id": 1,
            "baseName": "baseName1",
            "basePath": "childPath1_1",
            "pathChildList": null
        },
        {
            "createBy": "sun_base",
            "createTime": "2023-12-18T07:59:29.000+00:00",
            "updateBy": "random_base",
            "updateTime": "2023-12-18T08:00:09.000+00:00",
            "id": 1,
            "baseName": "baseName1",
            "basePath": "childPath1_2",
            "pathChildList": null
        },
        {
            "createBy": "sun2_base",
            "createTime": "2023-12-18T07:59:30.000+00:00",
            "updateBy": "randompro_base",
            "updateTime": "2023-12-18T08:00:09.000+00:00",
            "id": 2,
            "baseName": "baseName2",
            "basePath": "childPath2_2",
            "pathChildList": null
        }
    ]
    ~~~

3. 多表嵌套查询
    ~~~java
    // 实体类Base(类名对应具体的表名 使用驼峰命名法，如表名为user_role,则类名应写为UserRole) 嵌套查询中使用到的多个实体若均可映射到对应表中的如上四个字段的值（只要该实体通过继承、直接添加的方式获取到了以上声明的四个实体属性的getter/setter方法即可）
    @Data
    public class Base extends BaseDomain {
      private int id;
      private String baseName;
      private String basePath;
      private List<Child> pathChildList;
    }

    @Data
    public class Child extends BaseDomain {
      private int childId;
      private int parentId;
      private String childName;
      private String path;
    }

    // 公共字段
    @Data
    public class BaseDomain {
      private String createBy;
      private Date createTime;
      private String updateBy;
      private Date updateTime;
    }

    // Mapper接口
    @Mapper
    public interface TestMapper {
      List<Base> getPathList();
    }

    // Controller
    @RestController
    @RequestMapping("user")
    public record UserController(TestMapper testMapper) {
      @GetMapping("getPathList")
      public List<Base> getPathList() {
        return testMapper.getPathList();
      }
    }
    ~~~

   Mapper.xml：
    ~~~xml
    <?xml version="1.0" encoding="UTF-8" ?>
    <!DOCTYPE mapper
            PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
            "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
    <mapper namespace="com.live.mapper.TestMapper">

        <resultMap type="com.live.domian.Base" id="PathDomainMap">
            <result property="id"    column="id"    />
            <result property="baseName" column="base_name"/>
            <result property="basePath" column="base_path"/>

            <collection property="pathChildList" ofType="com.live.domian.Child">
                <id property="childId" column="child_id"/>
                <result property="parentId" column="parent_id"/>
                <result property="childName" column="child_name"/>
                <result property="path" column="path"/>
            </collection>
        </resultMap>

        <select id="getPathList" resultMap="PathDomainMap">
            SELECT base.id, base.base_name, base.base_path, child.id AS child_id, child.name AS child_name,
                  child.path, child.parent_id FROM base LEFT JOIN child ON base.id = child.parent_id
        </select>
    </mapper>
    ~~~

   访问user/getPathList获取结果，可见嵌套查询中每个层次都取到了公共字段createBy、createTime、updateBy、updateTime的值：

    ~~~json
    [
        {
            "createBy": "sun_base",
            "createTime": "2023-12-18T07:59:29.000+00:00",
            "updateBy": "random_base",
            "updateTime": "2023-12-18T08:00:09.000+00:00",
            "id": 1,
            "baseName": "baseName1",
            "basePath": "basePath1",
            "pathChildList": [
                {
                    "createBy": "sun12",
                    "createTime": "2023-12-18T07:58:59.000+00:00",
                    "updateBy": "RANDOM",
                    "updateTime": "2023-12-18T07:59:20.000+00:00",
                    "childId": 2,
                    "parentId": 1,
                    "childName": "childName1_2",
                    "path": "childPath1_2"
                },
                {
                    "createBy": "sun11",
                    "createTime": "2023-12-18T07:58:58.000+00:00",
                    "updateBy": "random",
                    "updateTime": "2023-12-18T07:59:19.000+00:00",
                    "childId": 1,
                    "parentId": 1,
                    "childName": "childName1_1",
                    "path": "childPath1_1"
                }
            ]
        },
        {
            "createBy": "sun2_base",
            "createTime": "2023-12-18T07:59:30.000+00:00",
            "updateBy": "randompro_base",
            "updateTime": "2023-12-18T08:00:09.000+00:00",
            "id": 2,
            "baseName": "baseName2",
            "basePath": "basePath2",
            "pathChildList": [
                {
                    "createBy": "sun21",
                    "createTime": "2023-12-18T07:59:00.000+00:00",
                    "updateBy": "randompro",
                    "updateTime": "2023-12-18T07:59:21.000+00:00",
                    "childId": 3,
                    "parentId": 2,
                    "childName": "childName2_1",
                    "path": "childPath2_2"
                }
            ]
        }
    ]
    ~~~
   嵌套查询中，如果只希望获取到特定的表的那四个公共属性，则把不希望获取公共属性的表对应的实体类中的四个映射属性去掉（若使用BaseDomain继承来的四个属性的的话去掉继承BaseDomain）即可
## 后续工作
1. 公共字段不再局限于创建人、创建时间、修改人、修改时间这四个，变更为可灵活调整配置的方式
2. 实体属性与数据表的关系后续可能会添加使用实体类添加注解的方式指定目标表，提供更大灵活性
3. 构建SpringBootAutoConfiguration工程实现拦截器插件自动配置

## 题外话
如果对你觉得这个项目对你有用，欢迎点点右上角Star给作者鼓励 ：）
