package com.woniper.converter.service.impl;

import com.woniper.converter.service.DatabaseService;
import org.apache.commons.dbcp.BasicDataSource;
import org.springframework.stereotype.Service;

import javax.sql.DataSource;

/**
 * Created by woniper on 2014. 6. 3..
 */
@Service
public class DatabaseServiceImpl implements DatabaseService {

    @Override
    public DataSource createDataSource(String url, String username, String password) {
        BasicDataSource dataSource = new BasicDataSource();
        dataSource.setDriverClassName("com.mysql.jdbc.Driver");
        dataSource.setUrl(url);
        dataSource.setUsername(username);
        dataSource.setPassword(password);
        return dataSource;
    }
}
