package com.woniper.converter.databases;

import javax.sql.DataSource;

public class Oracle implements DatabaseSelector {

	@Override
	public DataSource dataSource() {
		return null;
	}

}
