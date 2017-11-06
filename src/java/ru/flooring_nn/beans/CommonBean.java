package ru.flooring_nn.beans;

import java.io.BufferedInputStream;
import java.io.ByteArrayInputStream;
import java.io.DataInputStream;
import java.io.EOFException;
import java.io.IOException;
import java.lang.reflect.Method;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Vector;

import ru.flooring_nn.sql.Connect;

public class CommonBean {

	public HashMap<String, List<HashMap<String, String>>> results = new HashMap<String, List<HashMap<String, String>>>();
	private HashMap<String, String> pars = new HashMap<String, String>();
	private int level = 0;
	private int page = 1;
	private final static int PAGE_SIZE = 16;
	private Basket basket = null;
	private LevelParameters allParamsSession = null;

	public void initBasket() {
		if (basket == null) {
			basket = new Basket();
		}
	}

	public Basket getBasket() {
		if (basket == null) {
			initBasket();
		}
		return basket;
	}

	public void setBasket(Basket bskt) {
		this.basket = bskt;
	}

	public void initAllParams() {
		if (allParamsSession == null) {
			allParamsSession = new LevelParameters();
		}
	}

	public LevelParameters getAllParams() {
		if (allParamsSession == null) {
			initAllParams();
		}
		return allParamsSession;
	}

	public void addAllParams(List<HashMap<String, String>> levelParams) {
		if (allParamsSession == null) {
			initAllParams();
		}
		allParamsSession.addToQueLevels(levelParams);
	}

	public static int getPageSize() {
		return PAGE_SIZE;
	}

	public void setPars(HashMap<String, String> pars) {
		this.pars = pars;
	}

	public HashMap<String, String> getPars() {
		return pars;
	}

	public static Connection getConnection() throws Exception {
		return Connect.getConnection();
	}

	public int getLevel() {
		return level;
	}

	public void setLevel() {
		try {
			level = Integer.parseInt(pars.get("level"));
		} catch (Exception e) {
			level = 0;
			pars = new HashMap<String, String>();
		}
	}

	public void setPage() {
		try {
			page = Integer.parseInt(pars.get("page"));
		} catch (Exception e) {
			page = 1;
		}
	}

	public int getPage() {
		return page;
	}

	private void cleanResults() {
		results = new HashMap<String, List<HashMap<String, String>>>();
	}

	public String getNormPrefix(int num, String str) {
		int i = num % 10;
		if (i == 1 && num != 11) {
			return str;
		} else {
			if (i > 1 && i < 5 && (num < 5 || num > 20)) {
				return str + "а";
			}

		}
		return str + "ов";
	}

	public HashMap<String, Vector<HashMap<String, String>>> getResult() {
		return null;
	}

	public HashMap<String, List<HashMap<String, String>>> getResult(String ClassName, String MethodName) {
		cleanResults();
		HashMap<String, List<HashMap<String, String>>> result = new HashMap<String, List<HashMap<String, String>>>();
		List<ListSQL> requestsVec = new ArrayList<ListSQL>();
		try {
			Object object = Class.forName(ClassName).newInstance();
			Class[] classes = { this.getClass() };
			Method method = object.getClass().getMethod(MethodName, classes);
			requestsVec = (List<ListSQL>) method.invoke(object, new Object[] { this });
		} catch (Exception e) {
		}
		A resClass = new A();
		long timerStart = new Date().getTime();
		result = resClass.getResultSet(requestsVec);
		long timerEnd = new Date().getTime();
		System.out.println("TimerCommon: " + (timerEnd - timerStart) + " msec");
		return result;

	}

	public final static int MIN_LENGTH = 0;

	public static String getString(byte[] gzip, int size) throws IOException {
		// int size = gzip.length;
		if (size > MIN_LENGTH) {
			ByteArrayInputStream bais = new ByteArrayInputStream(gzip);
			DataInputStream inStream = new DataInputStream(new BufferedInputStream(bais));
			StringBuffer buffer = new StringBuffer(size);
			while (inStream.available() != 0) {
				try {
					buffer.append(inStream.readChar());
				} catch (EOFException e) {
					break;
				}
			}
			/*
			 * DataInputStream stream = new DataInputStream(new
			 * GZIPInputStream(bais)); StringBuffer buffer = new
			 * StringBuffer(size); for (int index = 0;
			 * buffer.toString().indexOf("</report>")==-1; index++) {
			 * buffer.append(stream.readChar()); }
			 */
			return buffer.toString();
		} else {
			return gzip.toString();
		}
	}

	private class A implements Runnable {
		private String sql;
		private List<Object> setPars;
		private int page = 1;
		private int maxRows;

		public A() {

		}

		public A(String sql, List<Object> setPars, int page, int maxRows) {
			this.sql = sql;
			this.setPars = setPars;
			this.page = page;
			this.maxRows = maxRows;
		}

		private HashMap<String, List<HashMap<String, String>>> getResultSet(List<ListSQL> sqlVector) {

			for (ListSQL req : sqlVector) {
				int index = sqlVector.indexOf(req);
				String sql = req.getSql();
				List<Object> setPars = req.getSetPars();
				int page = this.page;
				try {
					page = req.getPage();
				} catch (Exception e) {
				}

				int maxRows = PAGE_SIZE;
				try {
					maxRows = req.getMaxRows();
				} catch (Exception e) {
				}

				A myThread = new A(sql, setPars, page, maxRows);
				new Thread(myThread, "Request_" + index).start();

			}
			while (true) {
				if (results != null && results.size() == sqlVector.size())
					return results;
			}
		}

		@Deprecated
		private List<HashMap<String, String>> getResultSetOld(List<String> sqlVector, List<Object> sqlParams) {

			List<HashMap<String, String>> result = new ArrayList<HashMap<String, String>>();
			PreparedStatement stmt = null;
			Connection con = null;
			try {
				con = getConnection();
			} catch (Exception e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			if (con != null) {
				for (String sql : sqlVector) {
					List<Object> setPars = (List<Object>) sqlParams.get(sqlVector.indexOf(sql));
					try {
						stmt = con.prepareStatement(sql.toString());
						for (int i = 0; i < setPars.size(); i++) {
							stmt.setObject(i + 1, setPars.get(i));
						}
						ResultSet rs = stmt.executeQuery();
						int cols = rs.getMetaData().getColumnCount();
						int row_num = 0;
						while (rs.next()) {
							if ((row_num >= (getPage() - 1) * PAGE_SIZE) && (row_num < getPage() * PAGE_SIZE)) {
								HashMap<String, String> column = new HashMap<String, String>();
								for (int i = 1; i <= cols; i++) {
									String name = rs.getMetaData().getColumnName(i);
									String val = rs.getString(i);
									column.put(name, val);
								}
								result.add(column);
							} else if (row_num >= getPage() * PAGE_SIZE) {
								break;
							}
							row_num++;
						}
						rs.last();
						HashMap<String, String> rows = new HashMap<String, String>();
						// int pages = (int) Math.ceil(rs.getRow() /
						// (PAGE_SIZE*1.0));

						rows.put("ROWS", String.valueOf(rs.getRow()));
						result.add(rows);
						stmt.close();
						con.close();
						rs.close();
					} catch (Exception e) {
						try {
							if (con != null && !con.isClosed())
								con.close();
						} catch (SQLException e1) {
							// TODO Auto-generated catch block
							e1.printStackTrace();
						}
						try {
							if (stmt != null && !stmt.isClosed())
								stmt.close();
						} catch (SQLException e1) {
							// TODO Auto-generated catch block
							e1.printStackTrace();
						}
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
				}
			}
			return result;
		}

		public void run() {
			// TODO Auto-generated method stub
			long timerStart1 = new Date().getTime();

			Thread thr = Thread.currentThread();
			String thrName = thr.getName();
			List<HashMap<String, String>> result = new ArrayList<HashMap<String, String>>();

			// System.out.println(thrName+"\r\nSQL: "+this.sql+"\r\nPARAMS:
			// "+this.setPars);

			PreparedStatement stmt = null;
			Connection con = null;
			try {
				con = getConnection();
			} catch (Exception e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			if (con != null) {
				long timerStart2 = new Date().getTime();

				try {
					stmt = con.prepareStatement(sql.toString());
					for (int i = 0; i < setPars.size(); i++) {
						stmt.setObject(i + 1, setPars.get(i));
					}
					ResultSet rs = stmt.executeQuery();

					long timerEnd2 = new Date().getTime();
					// System.out.println("TimerThreadRequest["+thrName+"]:
					// "+(timerEnd2-timerStart2)+" msec");

					int cols = rs.getMetaData().getColumnCount();
					int row_num = 0;
					while (rs.next()) {
						if ((row_num >= (page - 1) * maxRows) && (row_num < page * maxRows)) {
							HashMap<String, String> column = new HashMap<String, String>();
							for (int i = 1; i <= cols; i++) {
								String name = rs.getMetaData().getColumnLabel(i);
								String val = rs.getString(i);

								column.put(name, val);
							}
							result.add(column);
							// addResult(column);
						} else if (row_num >= page * maxRows) {
							break;
						}
						row_num++;
					}
					rs.last();
					HashMap<String, String> rows = new HashMap<String, String>();
					// int pages = (int) Math.ceil(rs.getRow() /
					// (PAGE_SIZE*1.0));

					rows.put("ROWS", String.valueOf(rs.getRow()));
					result.add(rows);

					synchronized (results) {
						results.put(thrName, result);
					}

					// addResult(thrName, result);
					stmt.close();
					con.close();
					rs.close();
					long timerEnd1 = new Date().getTime();
					// System.out.println("TimerThread["+thrName+"]:
					// "+(timerEnd1-timerStart1)+"
					// msec\r\n-----------------------------------------------");

				} catch (Exception e) {
					results.put("ERROR", new ArrayList<HashMap<String, String>>());
					try {
						if (con != null && !con.isClosed())
							con.close();
					} catch (SQLException e1) {
						// TODO Auto-generated catch block
						e1.printStackTrace();
					}
					try {
						if (stmt != null && !stmt.isClosed())
							stmt.close();
					} catch (SQLException e1) {
						// TODO Auto-generated catch block
						e1.printStackTrace();
					}
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}

		}

	}
}
