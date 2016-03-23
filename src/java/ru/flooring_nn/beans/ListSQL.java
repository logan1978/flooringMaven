package ru.flooring_nn.beans;

import java.util.*;

public class ListSQL {
	private String sql;
	private List<Object> setPars = new ArrayList<Object>();
	private int maxRows = Integer.MAX_VALUE;
	private int page = 1;
	
	public ListSQL(String sql, List<Object> setPars) {
		// TODO Auto-generated constructor stub
		this.sql = sql;
		this.setPars = setPars;
	}

	public ListSQL(String sql, List<Object> setPars, int maxRows, int page) {
		// TODO Auto-generated constructor stub
		this.sql = sql;
		this.setPars = setPars;
		this.maxRows = maxRows;
		this.page = page;
	}

	public String getSql() {
		return sql;
	}
	
	public List<Object> getSetPars() {
		return setPars;
	}
	
	public int getPage() {
		return page;
	}
	
	public int getMaxRows() {
		return maxRows;
	}

}

