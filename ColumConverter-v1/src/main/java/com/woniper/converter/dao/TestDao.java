package com.woniper.converter.dao;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;
import javax.sql.DataSource;
import java.util.List;

/**
 * Created by woniper on 2014. 6. 4..
 */
@Repository
public class TestDao {

    private JdbcTemplate jdbcTemplate;

    public List getList(String query, DataSource dataSource) {
        jdbcTemplate = new JdbcTemplate(dataSource);
        return jdbcTemplate.queryForList(query);
    }

    public List getTable(String tbName, String query, DataSource dataSource) {
        jdbcTemplate = new JdbcTemplate(dataSource);
        jdbcTemplate.execute("use " + tbName);
        return jdbcTemplate.queryForList(query);
    }
}
