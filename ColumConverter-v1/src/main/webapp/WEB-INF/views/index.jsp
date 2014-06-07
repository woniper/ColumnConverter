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
                    var tableHtml = "";
                    for(var i = 0; i < count; i++) {
                        var id = "chk"+i;
                        tableHtml += "<tr onclick='checked("+id+")' onmouseover='this.bgColor=\"#EEEEEE\"' onmouseout='this.bgColor=\"#FFFFFF\"' >" +
                                        "<td><input type='checkbox' class='checkbox' id='"+id+"' checked='checked' /></td>" +
                                        "<td>"+data[i].db+"</td>" +
                                        "<td>"+data[i].tb+"</td>" +
                                        "<td>"+data[i].col+"</td>" +
                                        "<td>"+data[i].type+"</td>" +
                                     "</tr>";

                    }
                    document.getElementById("table").innerHTML += tableHtml;
                    getClassText();
                }
            });
        }
        function getClassText() {
            var data = [{"database" : "test", "table" : "test", "column" : "Test_id2",  "type" : "STring"},
                        {"database" : "test", "table" : "test", "column" : "test__id",  "type" : "STring"},
                        {"database" : "test", "table" : "test", "column" : "test-id",  "type" : "STring"}];
            $.ajax({
                url:"<%=cp%>/text",
                method:"POST",
                type:"json",
                contentType:"application/json",
                data:JSON.stringify(data),
                success:function(data) {
                    alert(data.text);
                    document.getElementById("textArea").innerHTML += data.text;
                }
            });
        }

        function allChecked() {

        }

        function checked(id) {
            document.getElementById(id).checked = checked;
        }
    </script>

    <input type="hidden" id="hiddenUrl" />
    <input type="hidden" id="hiddenUserName" />
    <input type="hidden" id="hiddenPassword" />

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
                        <li class="dropdown">
                            <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                                <span class="badge" id="dbCount"></span>
                                Databases
                                <b class="caret"></b>
                            </a>
                            <ul class="dropdown-menu" id="dbList"></ul>
                        </li>
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
            <div class="panel-body">
                <div style="overflow: auto; max-height: 450px; width: auto;">
                    <table class="table" id="table">
                        <tr>
                            <th><input type="checkbox" class="checkbox" onclick="allChecked();"/></th>
                            <th>DB Name</th>
                            <th>Table Name</th>
                            <th>Colunmn Name</th>
                            <th>Type Name</th>
                        </tr>
                    </table>
                </div>
            </div>
            <div class="panel-footer">
                <button type="button" class="btn btn-danger btn-lg" data-toggle="modal" data-target="#modal" >
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
                                <button type="button" class="btn btn-primary">SAVE</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>


</body>
</html>
