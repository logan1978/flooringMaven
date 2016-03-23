package ru.flooring_nn.beans;

import java.util.Iterator;
import java.util.Map;
import java.util.TreeMap;

public class Basket {
	private TreeMap<Integer, Integer> basketCount = new TreeMap<Integer, Integer>();
	private TreeMap<Integer, Integer> basketPrice = new TreeMap<Integer, Integer>();
	
	public Basket() {
		basketCount = new TreeMap<Integer, Integer>();
		basketPrice = new TreeMap<Integer, Integer>();
	}
	
	public void addToBasket(Integer id, Integer count, Integer price) {
		if(basketCount!=null) {
			if(basketCount.get(id) != null) {
				Integer cnt = basketCount.get(id);
				count += cnt;
			} 
			basketCount.put(id, count);
			basketPrice.put(id, price);
		}
	}
	 
	public void removeFromBasket(Integer id, Integer count) {
		if(basketCount != null) {
			if(basketCount.get(id) != null) {
				Integer cnt = basketCount.get(id);
				count -= cnt;
				if(count <= 0) {
					basketCount.remove(id);
					basketPrice.remove(id);
				} else {
					basketCount.put(id, count);
				}
			}
		}
	}
	
	public void clearBasket() {
		basketCount = new TreeMap<Integer, Integer>();
		basketPrice = new TreeMap<Integer, Integer>();
	}
	
	public Integer getFromBasketCount(Integer id) {
		if(basketCount != null) {
			return basketCount.get(id);
		} else {
			return null;
		}
	}
	
	public Integer getFromBasketPrice(Integer id) {
		if(basketPrice != null) {
			return basketPrice.get(id);
		} else {
			return null;
		}
	}

	public int getSizeBasket() {
		return basketCount.size();
	}

	public int getCountBasket() {
		int cnt=0;
		for(Map.Entry<Integer, Integer> item : basketCount.entrySet()) {
			cnt += item.getValue();
		}
		return cnt; 
	}
	
	public String getCommonPrice() {
		String commonPrice = "на заказ";
		int cnt=0;
		for(Map.Entry<Integer, Integer> item : basketCount.entrySet()) {
			int price = basketPrice.get(item.getKey());
			if(price != -1) {
				cnt += (item.getValue() * price);
			} else {
				return commonPrice;
			}
		}
		commonPrice = String.valueOf(cnt+" руб.");
		return commonPrice;
	}
}
