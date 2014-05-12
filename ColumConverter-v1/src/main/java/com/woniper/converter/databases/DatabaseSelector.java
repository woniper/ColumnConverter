package com.woniper.converter.databases;

import javax.sql.DataSource;

public interface DatabaseSelector {
	DataSource dataSource();
}
