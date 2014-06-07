package com.woniper.converter.dto;

import org.pojomatic.Pojomatic;
import org.pojomatic.annotations.AutoProperty;

@AutoProperty
public class DatabaseDto {

	private int dbKind;
	private String url;
	private String username;
	private String password;
	
	public int getDbKind() {
		return dbKind;
	}
	public void setDbKind(int dbKind) {
		this.dbKind = dbKind;
	}
	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	@Override
	public String toString() {
		return Pojomatic.toString(this);
	}
}
