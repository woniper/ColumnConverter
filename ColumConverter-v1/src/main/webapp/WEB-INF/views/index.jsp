<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
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
    
    <script>
        var name = "";
        var database = "";
        var table = "";
        function dbConnection() {
//		    var dbKind = document.getElementById("dbKind").value;
            var url = document.getElementById("url").value;
            var username = document.getElementById("username").value;
            var password = document.getElementById("password").value;
            var data = { "url":url, "username":username, "password":password };

	        $.ajax({
	        	   url:"<%=cp%>/connect",
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
            var url = document.getElementById("hiddenUrl").value;
            var username = document.getElementById("hiddenUserName").value;
            var password = document.getElementById("hiddenPassword").value;
            var data = { "url":url, "username":username, "password":password };

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
                        listTag += "<li><a href='#' onclick='javascript:getField("+"\""+tbName+"\""+")'>" + tbName + "</a></li>";
                    }
                    document.getElementById("tbList").innerHTML = listTag;
                    name = dbName + " / ";
                    database = dbName;
                },
                error:function(error) {
                    alert("오류");
                }
            });
        }
        function getField(tbName) {
            var url = document.getElementById("hiddenUrl").value;
            var username = document.getElementById("hiddenUserName").value;
            var password = document.getElementById("hiddenPassword").value;
            var data = { "url":url, "username":username, "password":password };
            table = tbName;
            document.getElementById("name").innerHTML = name + tbName;
            $.ajax({
                url:"<%=cp%>/field?db="+database+"&tb="+table,
                method:"POST",
                type:"json",
                contentType:"application/json",
                data:JSON.stringify(data),
                success:function(data) {
                    var text = getClassText(data);
                    document.getElementById("textArea").innerHTML = text;
                }
            });
        }
        function getClassText(str) {
            var resultStr = "";
            var count = str.length;
            if(count > 0) {
                resultStr += "public class " + classToUpperCase(str[0].tb) + " { \n";
                for(var i = 0; i < count; i++) {
                    resultStr += "      private" + getVariable(str[i].type) + fieldToUpperCase(str[i].col) + ";\n"
                }
                resultStr += "}";
            } else {
                resultStr = "";
            }
            return resultStr;
        }
        function getVariable(str) {
            var resultStr = "";
            if("bigint" == str)
                resultStr = " long ";
            else if("varchar" == str)
                resultStr = " String ";
            else if("timestamp" == str)
                resultStr = " Date ";
            else if("int" == str)
                resultStr = " int ";
            return resultStr;
        }
        function removeUnderBar(str) {
            var returnStr = "";
            returnStr = str.replace("_", "").replace("-","");
            return returnStr;
        }
        function fieldToUpperCase(str) {
            var count = str.length;
            var resultStr = "";
            var upperNum = -1;

            for(var i = 0; i < count; i++) {
                if(i == 0) {
                    resultStr += str.charAt(i).toLowerCase();
                    continue;
                }
                if((str.charAt(i) == "_") || (str.charAt(i) == "-")) {
                    resultStr += str.charAt(i+1).toUpperCase();
                    upperNum = i+1;
                } else {
                    if(i == upperNum)
                        continue;
                    else
                        resultStr += str.charAt(i);
                }
            }
            return resultStr;
        }
        function classToUpperCase(str) {
            var count = str.length;
            var resultStr = "";
            var upperNum = -1;

            for (var i = 0; i < count; i++) {
                if (i == 0) {
                    resultStr += str.charAt(i).toUpperCase();
                    continue;
                }
                if ((str.charAt(i) == "_") || (str.charAt(i) == "-")) {
                    resultStr += str.charAt(i + 1).toUpperCase();
                    upperNum = i + 1;
                } else {
                    if((i == upperNum))
                        continue;
                    else
                    resultStr += str.charAt(i);
                }
            }
            return resultStr;
        }
    </script>

    <input type="hidden" id="hiddenUrl" />
    <input type="hidden" id="hiddenUserName" />
    <input type="hidden" id="hiddenPassword" />

    <div style="height: auto; margin: 20px;">
        <div class="panel panel-primary">
            <div class="panel-heading">Database 정보 입력</div>
            <div class="panel-body">
                <nav class="navbar navbar-default" role="navigation">
                    <form class="navbar-form navbar-left" role="search">
                        <div class="form-group">
                            <input type="text" class="form-control" placeholder="URL" id="url" name="url" value="jdbc:mysql://popcorn5.c9nazwdesykr.ap-northeast-1.rds.amazonaws.com:3306" />
                            <input type="text" class="form-control" placeholder="UserName" id="username" name="username" value="popcorn5" />
                            <input type="password" class="form-control" placeholder="Password" id="password" name="password" value="Spicysh7672p!" />
                        </div>
                        <button type="button" class="btn btn-default" onclick="dbConnection();">Connect</button>
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

    <div style="height: auto; margin: 20px;">
        <div class="panel panel-primary">
            <div class="panel-heading" id="name"></div>
            <div class="panel-body">
                <textarea class="form-control" rows="50" cols="50" id="textArea">
                </textarea>
            </div>
        </div>
    </div>
</body>
</html>
