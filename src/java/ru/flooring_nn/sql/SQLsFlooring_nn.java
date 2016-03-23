package ru.flooring_nn.sql;

import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.apache.commons.lang3.StringUtils;

import ru.flooring_nn.beans.CommonBean;
import ru.flooring_nn.beans.ListSQL;

public class SQLsFlooring_nn {
	
	public List<ListSQL> getRequests(CommonBean obj) {
		List<ListSQL> requestsVec = new ArrayList<ListSQL>();
		HashMap<String, String> pars = obj.getPars(); 
		int PAGE_SIZE= obj.getPageSize();
		int page = obj.getPage();
		int level = obj.getLevel();
		
		if("poisk".equals(pars.get("id"))) {
			List <Object> setPars = new ArrayList<Object>();
			StringBuilder sql = new StringBuilder();
				sql.append("select t2.* from flooring.catalog as t1\r\n"+
					"	inner JOIN flooring.catalog_decor_name as t2 on t1.ID_DEC=t2.ID\r\n");
				String poisk=null;
				try {
					String phrase = new String(pars.get("poisk").getBytes("ISO-8859-1"), "utf-8");
					poisk = getRootPhrase(phrase)+"%";
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				if(poisk!=null) { 
					sql.append("	where \r\n"+
					"	(LOWER(t2.DECOR) like LOWER(?) or LOWER(t2.DESCRIPTION) like LOWER(?)) \r\n");
					setPars.add(poisk);
					setPars.add(poisk);
				}
				if("1".equals(pars.get("level_parent"))) {
					sql.append("	and t1.id_sec = ? \r\n");
					String id_parent = pars.get("id_parent");
					setPars.add(id_parent);
				} else if("2".equals(pars.get("level_parent"))) {
					sql.append("	and t1.id_firm = ? \r\n");
					String id_parent = pars.get("id_parent");
					setPars.add(id_parent);
				} else if("3".equals(pars.get("level_parent"))) {
					sql.append("	and t1.id_coll = ? \r\n");
					String id_parent = pars.get("id_parent");
					setPars.add(id_parent);
				}
			requestsVec.add(new ListSQL(sql.toString(), setPars, PAGE_SIZE, page));
		} else if(level==1) {
			List <Object> setPars = new ArrayList<Object>();
			StringBuilder sql = new StringBuilder("select distinct t2.*\r\n"+		
					"	from flooring.catalog as t1\r\n"+
					"	inner join flooring.catalog_firms_name as t2\r\n"+
					"	on t1.ID_SEC=t2.ID_SEC \r\n");
			String id = pars.get("id");
			if(id!=null) { 
				sql.append("where t1.id_sec=?\r\n");
				setPars.add(id);
			}
			requestsVec.add(new ListSQL(sql.toString(), setPars, PAGE_SIZE, page));
			sql =  new StringBuilder("select t1.SECTION, t1.ID ID_SECTION from flooring.catalog_sections_name as t1 \r\n");
			setPars = new ArrayList<Object>();
			if(id!=null) { 
				sql.append("where t1.id=?\r\n");
				setPars.add(id);
			}
			requestsVec.add(new ListSQL(sql.toString(), setPars));
		} else if(level==2) {
			List<Object> setPars = new ArrayList<Object>();
			StringBuilder sql = new StringBuilder("select distinct t2.*\r\n"+
					"	from flooring.catalog as t1\r\n"+
					"	inner join flooring.catalog_collections_name as t2\r\n"+
					"	on t1.ID_COLL=t2.ID and t1.ID_FIRM=t2.ID_FIRM\r\n");		
			String id = pars.get("id");
			if(id!=null) { 
				sql.append("where t1.id_firm=?\r\n");
				setPars.add(id);
			}
			requestsVec.add(new ListSQL(sql.toString(), setPars, PAGE_SIZE, page));
			sql =  new StringBuilder("select t1.FIRMA, t1.ID as ID_FIRMA, t2.SECTION, t2.ID as ID_SECTION from flooring.catalog_firms_name as t1\r\n"+ 
					"	inner join flooring.catalog_sections_name as t2 on t1.ID_SEC=t2.id\r\n");
			setPars = new ArrayList<Object>();
			if(id!=null) { 
				sql.append("where t1.id=?\r\n");
				setPars.add(id);
			}
			requestsVec.add(new ListSQL(sql.toString(), setPars));
			
			sql =  new StringBuilder("select t1.* from flooring.catalog_firms_name t1\r\n"+
					"	inner join flooring.catalog_firms_name as t2 \r\n"+
					"	on\r\n"+
					"	t1.ID_SEC=t2.ID_SEC\r\n");
			setPars = new ArrayList<Object>();
			if(id!=null) { 
				sql.append("and t2.id=?\r\n");
				setPars.add(id);
			}
			requestsVec.add(new ListSQL(sql.toString(), setPars));
		} else if(level==3) {
			List <Object> setPars = new ArrayList<Object>();
			StringBuilder sql = new StringBuilder("select distinct t2.*\r\n"+
					"	from flooring.catalog as t1\r\n"+
					"	inner join flooring.catalog_decor_name as t2\r\n"+
					"	on t1.ID_DEC=t2.ID and t1.ID_COLL=t2.ID_COLL\r\n");		
			String id = pars.get("id");
			if(id!=null) { 
				sql.append("where t1.id_coll=?\r\n");
				setPars.add(id);
			}
			requestsVec.add(new ListSQL(sql.toString(), setPars, PAGE_SIZE, page));
			sql =  new StringBuilder("select t1.COLLECTION, t1.ID as ID_COLLECTION, t2.FIRMA, t2.ID as ID_FIRMA, \r\n"
					+ "	t3.SECTION, t3.ID as ID_SECTION from flooring.catalog_collections_name t1\r\n"+
					"	inner join flooring.catalog_firms_name as t2 on t1.ID_FIRM=t2.ID\r\n"+
					"	inner join flooring.catalog_sections_name as t3 on t2.ID_SEC=t3.id\r\n");
			setPars = new ArrayList<Object>();
			if(id!=null) { 
				sql.append("where t1.id=?\r\n");
				setPars.add(id);
			}
			requestsVec.add(new ListSQL(sql.toString(), setPars));
			sql =  new StringBuilder("select t1.* from flooring.catalog_firms_name t1\r\n"+
					"	inner join flooring.catalog_firms_name t2\r\n"+
					"	on t1.ID_SEC=t2.ID_SEC\r\n"+
					"	inner join flooring.catalog_collections_name as t3\r\n"+ 
					"	on \r\n"+
					"	t2.ID=t3.ID_FIRM\r\n");
			setPars = new ArrayList<Object>();
			if(id!=null) { 
				sql.append("and t3.id=?\r\n");
				setPars.add(id);
			}
			requestsVec.add(new ListSQL(sql.toString(), setPars));
			
		} else if(level==4) {
			List <Object> setPars = new ArrayList<Object>();
			StringBuilder sql = new StringBuilder("select distinct t2.*\r\n"+
					"	from flooring.catalog as t1\r\n"+
					"	inner join flooring.catalog_decor_name as t2\r\n"+
					"	on t1.ID_DEC=t2.ID and t1.ID_COLL=t2.ID_COLL\r\n");		
			String id = pars.get("id");
			if(id!=null) { 
				sql.append("where t1.id_dec=?\r\n");
				setPars.add(id);
			}
			requestsVec.add(new ListSQL(sql.toString(), setPars, PAGE_SIZE, page));
			sql =  new StringBuilder("select t1.COLLECTION, t1.ID as ID_COLLECTION, t2.FIRMA, t2.ID as ID_FIRMA, \r\n"
					+ "	t3.SECTION, t3.ID as ID_SECTION from flooring.catalog_decor_name as t0\r\n"
					+ "	inner join flooring.catalog_collections_name t1 on t0.id_coll= t1.id\r\n"+
					"	inner join flooring.catalog_firms_name as t2 on t1.ID_FIRM=t2.ID\r\n"+
					"	inner join flooring.catalog_sections_name as t3 on t2.ID_SEC=t3.id\r\n");
			setPars = new ArrayList<Object>();
			if(id!=null) { 
				sql.append("where t0.id=?\r\n");
				setPars.add(id);
			}
			requestsVec.add(new ListSQL(sql.toString(), setPars));
		} else {
			List <Object> setPars = new ArrayList<Object>();
			StringBuilder sql = new StringBuilder("select * from flooring.catalog_sections_name");
			requestsVec.add(new ListSQL(sql.toString(), setPars));
		}

		return requestsVec;
	}

	private String  getRootPhrase(String commonPhrase) {
		String [] phrases = commonPhrase.split(" ");
		String phrase = "";
		String firstElem = phrases[0];
		int index = firstElem.length()-2;
		if(firstElem.toLowerCase().indexOf("ый")==index || 
				firstElem.toLowerCase().indexOf("ая")==index || 
						firstElem.toLowerCase().indexOf("ое")==index) {
				firstElem = firstElem.substring(0,index);
		}
		if(phrases.length==1) {
			return "%"+firstElem;
		} 
			phrase = "%"+firstElem+getRootPhrase(StringUtils.remove(commonPhrase, phrases[0]).trim());
			return phrase;
	}
}
