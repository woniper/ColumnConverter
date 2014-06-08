<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% String cp = request.getContextPath(); %>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="<%=cp%>/resources/bootstrap/css/bootstrap.min.css" rel="stylesheet">
	<title>Index</title>
</head>
<body>

    <script src="http://code.jquery.com/jquery-2.1.1.min.js" type="text/javascript"></script>
    <script src="<%=cp%>/resources/bootstrap/js/bootstrap.min.js"></script>
    <script src="<%=cp%>/resources/utils/commons.js"></script>

    <script type="text/javascript">
        function getConnectInfomation() {
            return data = { "url":document.getElementById("url").value,
                            "username":document.getElementById("username").value,
                            "password":document.getElementById("password").value
                          }
        }
        // DB연결 후 Database List
        function getDatabases() {
            var data = getConnectInfomation();

	        $.ajax({
	        	   url:"<%=cp%>/databases",
	        	   method:"POST",
	        	   type:"json",
	        	   contentType:"application/json",
	        	   data:JSON.stringify(data),
	        	   success:function(data) {
                       var count = data.length;
                       if(count <= 0) {
                           alert("Database가 없습니다.");
                           return;
                       }
                       document.getElementById("dbCount").innerHTML = count;
                       var listTag = "";
                       for(var i = 0; i < count; i++) {
                           var dbName = data[i].Database;
                           listTag += "<li><a href='#' onclick='javascript:getTables("+"\""+dbName+"\""+")'>"+dbName+"</a></li>";
                       }
                       document.getElementById("dbList").innerHTML = listTag;
                       document.getElementById("hiddenUrl").value = url;
                       document.getElementById("hiddenUserName").value = username;
                       document.getElementById("hiddenPassword").value = password;
                       document.getElementById("name").innerHTML = "";
		           },
                   error:function(error) {
                       alert("DB에 연결 할 수 없습니다.");
                       return;
                   }
            });
	    }
        // 선택한 DB의 Table List
        function getTables(dbName) {
            var data = getConnectInfomation();

            $.ajax({
                url:"<%=cp%>/tables/"+dbName,
                method:"POST",
                type:"json",
                contentType:"application/json",
                data:JSON.stringify(data),
                success:function(data) {
                    var count = data.length;
                    if(count <= 0) {
                        alert("Table이 없습니다.");
                    }
                    document.getElementById("tbCount").innerHTML = count;
                    var listTag = "";
                    for(var i = 0; i < count; i++) {
                        var tbName = data[i].name;
                        listTag += "<li><a href='#' onclick='javascript:getFields("+"\""+dbName+"\", "+"\""+tbName+"\""+")'>" + tbName + "</a></li>";
                    }
                    document.getElementById("tbList").innerHTML = listTag;
                },
                error:function(error) {
                    alert("오류");
                }
            });
        }
        // 선택한 Table의 Field List
        function getFields(dbName, tbName) {
            var data = getConnectInfomation();
            document.getElementById("name").innerHTML = dbName + " / " + tbName;
            $.ajax({
                url:"<%=cp%>/fields?db="+dbName+"&tb="+tbName,
                method:"POST",
                type:"json",
                contentType:"application/json",
                data:JSON.stringify(data),
                success:function(data) {
                    var count = data.length;
                    var tableHtml =  "<tr>" +
                                        "<th><input type='checkbox' id='chkAll' class='checkbox' checked='checked' onclick='checkedAll();'/></th>"+
                                        "<th>DB Name</th>"+
                                        "<th>Table Name</th>"+
                                        "<th>Colunmn Name</th>"+
                                        "<th>Type Name</th>"+
                                      "</tr>";
                    for(var i = 0; i < count; i++) {
                        var id = "chk"+i;
                        tableHtml += "<tr onmouseover='this.bgColor=\"#EEEEEE\"' onmouseout='this.bgColor=\"#FFFFFF\"' style='cursor: pointer;' >" +
                                        "<td onclick='isCheckedAll()'>"+
                                            "<input type='checkbox' checked='checked' name='checkbox' class='checkbox' id='"+id+"' />"+
                                        "</td>" +
                                        "<td onclick='checked("+id+")' name='database'>"+data[i].db+"</td>" +
                                        "<td onclick='checked("+id+")' name='table'>"+data[i].tb+"</td>" +
                                        "<td onclick='checked("+id+")' name='column'>"+data[i].col+"</td>" +
                                        "<td onclick='checked("+id+")' name='type'>"+data[i].type+"</td>" +
                                     "</tr>";

                    }
                    document.getElementById("table").innerHTML = tableHtml;
                }
            });
        }
        // Field -> 변수명으로 생성
        function create() {
            var checkbox = document.getElementsByName("checkbox");
            var db = document.getElementsByName("database");
            var tb = document.getElementsByName("table");
            var col = document.getElementsByName("column");
            var type = document.getElementsByName("type");

            var count = checkbox.length;
            var data = new Array();

            for(var i = 0; i < count; i++) {
                if(checkbox[i].checked) {
                    sub = new Object();
                    sub['database'] = db[i].innerHTML;
                    sub['table'] = tb[i].innerHTML;
                    sub['column'] = col[i].innerHTML;
                    sub['type'] = type[i].innerHTML;
                    data[data.length] = sub;
                }
            }
            if(data.length == 0) {
                document.getElementById("textArea").innerHTML = "";
                return;
            }

            $.ajax({
                url:"<%=cp%>/text",
                method:"POST",
                type:"json",
                contentType:"application/json",
                data:JSON.stringify(data),
                success:function(data) {
                    document.getElementById("textArea").innerHTML = data.text;
                }
            });
        }
        // checkbox 전체 선택
        function checkedAll() {
            var all = document.getElementById("chkAll");
            var doc = document.getElementsByName("checkbox");
            var count = doc.length;
            if(all.checked) {
                for(var i = 0; i < count; i++) {
                    doc[i].checked = true;
                }
            } else {
                for(var i = 0; i < count; i++) {
                    doc[i].checked = false;
                }
            }
        }
        // checkbox checked
        function checked(chk) {
            if(chk.checked) {
                chk.checked = false;
            } else {
                chk.checked = true;
            }
            isCheckedAll();
        }
        // checkbox 전체 체크 여부
        function isCheckedAll() {
            var doc = document.getElementsByName("checkbox");
            for(var i = 0; i < doc.length; i++) {
                if(!doc[i].checked) {
                    document.getElementById("chkAll").checked = false;
                    break;
                } else {
                    document.getElementById("chkAll").checked = true;
                }
            }
        }
    </script>

    <input type="hidden" id="hiddenUrl" />
    <input type="hidden" id="hiddenUserName" />
    <input type="hidden" id="hiddenPassword" />

    <%--DB 정보 입력--%>
    <div style="height: auto; margin: 20px;">
        <div class="panel panel-primary">
            <div class="panel-heading">Database Information</div>
            <div class="panel-body">
                <%--연결 정보--%>
                <nav class="navbar navbar-default" role="navigation">
                    <form class="navbar-form navbar-left" role="search">
                        <div class="form-group">
                            <input type="text" class="form-control" placeholder="URL" id="url" name="url" value="jdbc:mysql://localhost:3306" />
                            <input type="text" class="form-control" placeholder="UserName" id="username" name="username" value="root" />
                            <input type="password" class="form-control" placeholder="Password" id="password" name="password" value="1234" />
                        </div>
                        <button type="button" class="btn btn-default" onclick="getDatabases();">Connect</button>
                    </form>
                    <ul class="nav navbar-nav">
                        <%--DB dropdown--%>
                        <li class="dropdown">
                            <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                                <span class="badge" id="dbCount"></span>
                                Databases
                                <b class="caret"></b>
                            </a>
                            <ul class="dropdown-menu" id="dbList"></ul>
                        </li>
                        <%--Table dropdown--%>
                        <li class="dropdown">
                            <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                                <span class="badge" id="tbCount"></span>
                                Tables
                                <b class="caret"></b>
                            </a>
                            <ul class="dropdown-menu" id="tbList"></ul>
                        </li>
                    </ul>
                </nav>
            </div>
        </div>
    </div>

    <div style="max-height: 500px; margin: 20px;">
        <div class="panel panel-primary">
            <div class="panel-heading" id="name"></div>
            <div style="overflow: auto; max-height: 450px; width: auto;">
                <table class="table" id="table">

                </table>
            </div>
            <div class="panel-footer">
                <button onclick="create()" type="button" class="btn btn-danger btn-lg" data-toggle="modal" data-target="#modal" >
                    <span class="glyphicon glyphicon-ok"></span>
                    Create
                </button>
                <div class="modal fade" id="modal" tabindex="-1" role="dialog" aria-labelledby="label" aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                                <h4 class="modal-title" id="label">Modal title</h4>
                            </div>
                            <div class="modal-body">
                                <textarea style="width: 500px; height: 550px;" id="textArea"></textarea>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                                <button type="button" class="btn btn-primary" onclick="save">SAVE</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>


</body>
</html>
