package com.woniper.converter.config;

import javax.sql.DataSource;

import org.apache.commons.dbcp.BasicDataSource;
import org.springframework.beans.factory.config.PropertyPlaceholderConfigurer;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.annotation.TransactionManagementConfigurer;

@Configuration
public class DatabaseConfiguration implements TransactionManagementConfigurer {

	@Bean
	public static PropertyPlaceholderConfigurer propertyPlaceholderConfigurer() {
		PropertyPlaceholderConfigurer pp = new PropertyPlaceholderConfigurer();
//		pp.setLocations(new Resource[]{ new ClassPathResource(JDBC_CONFIG_PATH),
//										new ClassPathResource(ERROR_CODE_PATH) });
		return pp;
	}
	
	@Bean
	public DataSource dataSource() {
		BasicDataSource dataSource = new BasicDataSource();
//		dataSource.setDriverClassName(driverClassName);
//		dataSource.setUrl(jdbcUrl);
//		dataSource.setUsername(jdbcUserName);
//		dataSource.setPassword(jdbcPassword);
		return dataSource;
	}

	@Override
	public PlatformTransactionManager annotationDrivenTransactionManager() {
		// TODO Auto-generated method stub
		return null;
	}
	
}
