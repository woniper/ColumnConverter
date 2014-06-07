package com.woniper.converter.dao;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import javax.sql.DataSource;
import java.util.List;

/**
 * Created by woniper on 2014. 6. 4..
 */
@Repository
public class DatabaseDao {

    private JdbcTemplate jdbcTemplate;

    /*
    *
    * */
    public List getDatabases(DataSource dataSource) {
        jdbcTemplate = new JdbcTemplate(dataSource);
        return jdbcTemplate.queryForList("show databases");
    }

    public List getTables(String name, DataSource dataSource) {
        jdbcTemplate = new JdbcTemplate(dataSource);
        return jdbcTemplate.queryForList("select Table_name name from information_schema.tables where TABLE_SCHEMA = '"+name+"'");
    }

    public List getFields(String dbName, String tbName, DataSource dataSource) {
        jdbcTemplate = new JdbcTemplate(dataSource);
        return jdbcTemplate.queryForList("select TABLE_SCHEMA db, Table_name tb, Column_name col, DATA_TYPE type " +
                                            "from information_schema.COLUMNS " +
                                            "where TABLE_SCHEMA = '"+dbName+"' and TABLE_NAME = '"+tbName+"'");
    }
}
