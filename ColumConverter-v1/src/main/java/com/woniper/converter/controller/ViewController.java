package com.woniper.converter.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class ViewController {

	@RequestMapping(value="/index")
	public ModelAndView main() {
		ModelAndView model = new ModelAndView("index");
		model.addObject("text", "test");
		return model;
	}
}
