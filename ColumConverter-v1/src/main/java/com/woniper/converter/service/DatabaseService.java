package com.woniper.converter.service;

import javax.sql.DataSource;

/**
 * Created by woniper on 2014. 6. 3..
 */
public interface DatabaseService {

    DataSource createDataSource(String url, String username, String password);
}
