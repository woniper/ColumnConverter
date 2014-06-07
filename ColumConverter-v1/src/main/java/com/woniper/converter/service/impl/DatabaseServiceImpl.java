package com.woniper.converter.service.impl;

import com.woniper.converter.dto.DatabaseDto;
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
    public DataSource createDataSource(DatabaseDto dto) {
        BasicDataSource dataSource = new BasicDataSource();
        dataSource.setDriverClassName("com.mysql.jdbc.Driver");
        dataSource.setUrl(dto.getUrl());
        dataSource.setUsername(dto.getUsername());
        dataSource.setPassword(dto.getPassword());
        return dataSource;
    }
}
