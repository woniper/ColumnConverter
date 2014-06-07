package com.woniper.converter.controller;

import com.woniper.converter.convert.FieldTextConvert;
import com.woniper.converter.dao.DatabaseDao;
import com.woniper.converter.dto.DatabaseDto;
import com.woniper.converter.dto.InfomationSchemaDto;
import com.woniper.converter.service.DatabaseService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class ConvertController {

    @Autowired private DatabaseService service;
    @Autowired private DatabaseDao databaseDao;
    @Autowired private FieldTextConvert fieldTextConvert;

    @RequestMapping(value = "/index", method = RequestMethod.GET)
    public ModelAndView index() {
        return new ModelAndView("index");
    }

    @RequestMapping(value="/databases", method=RequestMethod.POST, produces={MediaType.APPLICATION_JSON_VALUE})
    public @ResponseBody List databases(@RequestBody DatabaseDto dto) {
        return databaseDao.getDatabases(service.createDataSource(dto));
    }

    @RequestMapping(value = "/tables/{name}", method = RequestMethod.POST, produces = {MediaType.APPLICATION_JSON_VALUE})
    public @ResponseBody List tables(@PathVariable String name, @RequestBody DatabaseDto dto) {
        return databaseDao.getTables(name, service.createDataSource(dto));
    }

    @RequestMapping(value = "/fields", params = {"db", "tb"}, method = RequestMethod.POST, produces = {MediaType.APPLICATION_JSON_VALUE})
    public @ResponseBody List fields(@RequestParam("db") String dbName,
                                     @RequestParam("tb") String tbName,
                                     @RequestBody DatabaseDto dto) {
        return databaseDao.getFields(dbName, tbName, service.createDataSource(dto));
    }

    @RequestMapping(value = "/text", method = RequestMethod.POST, produces = {MediaType.APPLICATION_JSON_VALUE})
    public @ResponseBody Map<String, Object> getClassText(@RequestBody List<InfomationSchemaDto> list) {
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("text", fieldTextConvert.getClassText(list));
        return map;
    }
	
}
