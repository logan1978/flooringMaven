package ru.flooring_nn.beans;

import java.util.*;

public class LevelParameters {
	
	private Deque<List<HashMap<String, String>>> queLevels = new ArrayDeque<List<HashMap<String, String>>>(); 
	
	public Deque<List<HashMap<String, String>>> getQueLevels() {
		return queLevels;
	}
	
	public void setQueLevels(Deque<List<HashMap<String, String>>> queLevels) {
		this.queLevels = queLevels;
	}
	
	public void addToQueLevels(List<HashMap<String, String>> levelParams) {
		queLevels.addLast(levelParams);
	}
	
	public List<HashMap<String, String>> getFromQueLevels() {
		return queLevels.peekFirst();
	}
}
