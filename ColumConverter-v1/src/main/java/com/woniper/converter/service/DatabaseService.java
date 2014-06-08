package com.woniper.converter.service;

import com.woniper.converter.dto.DatabaseDto;

import javax.sql.DataSource;

/**
 * Created by woniper on 2014. 6. 3..
 */
public interface DatabaseService {
    DataSource createDataSource(DatabaseDto dto);
}
