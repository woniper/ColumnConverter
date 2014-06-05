package com.woniper.converter.controller;

import com.woniper.converter.dao.TestDao;
import com.woniper.converter.dto.DBConfigDto;
import com.woniper.converter.service.DatabaseService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import javax.sql.DataSource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class ConvertController {

    @Autowired private DatabaseService service;
    @Autowired private TestDao testDao;

    @RequestMapping(value = "/index", method = RequestMethod.GET)
    public ModelAndView index() {
        return new ModelAndView("index");
    }

    @RequestMapping(value="/connect", method=RequestMethod.POST, produces={MediaType.APPLICATION_JSON_VALUE})
    public @ResponseBody List connect(@RequestBody DBConfigDto dto) {
        DataSource dataSource = service.createDataSource(dto.getUrl(), dto.getUsername(), dto.getPassword());
        List list = testDao.getList("show databases", dataSource);
        return list;
    }

    @RequestMapping(value = "/tables/{name}", method = RequestMethod.POST, produces = {MediaType.APPLICATION_JSON_VALUE})
    public @ResponseBody List tables(@PathVariable String name, @RequestBody DBConfigDto dto) {
        DataSource dataSource = service.createDataSource(dto.getUrl(), dto.getUsername(), dto.getPassword());
        List list = testDao.getList("select Table_name name from information_schema.tables where TABLE_SCHEMA = '"+name+"'", dataSource);
        return list;
    }

    @RequestMapping(value = "/field", params = {"db", "tb"}, method = RequestMethod.POST, produces = {MediaType.APPLICATION_JSON_VALUE})
    public @ResponseBody List field(@RequestParam("db") String dbName, @RequestParam("tb") String tbName, @RequestBody DBConfigDto dto) {
        DataSource dataSource = service.createDataSource(dto.getUrl(), dto.getUsername(), dto.getPassword());
        List list = testDao.getList(
                "select TABLE_SCHEMA db, Table_name tb, Column_name col, DATA_TYPE type " +
                        "from information_schema.COLUMNS " +
                        "where TABLE_SCHEMA = '"+dbName+"' and TABLE_NAME = '"+tbName+"'", dataSource);
        return list;
    }
	
}
