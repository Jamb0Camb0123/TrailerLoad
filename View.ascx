<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="View.ascx.cs" Inherits="Morningfoods.Modules.HJLeaTrailerLoad.View" %>

<br />

<div id ="loading"></div>

<div id="pg1">
    <br />
    <div class="mySearch">
        <div class="search-group">
            <input type="text" id="myInput" placeholder="Search for a Trailer ID" list="trlr_data">
            <button id="myButton" type="button">Search</button>
        </div>
        <button id="addButton" type="button">New Trailer Load</button>
    </div>


    <br />

    <div class="col-sm-12">
        <div class="panel panel-default">
        <table class="table table-responsive table-hover">
            <thead>
            <tr>
                <th>Trailer ID</th>
                <th>NOPS Trailer</th>
                <th>Date Loaded</th>
                <th>Site Loaded</th>
            </tr> 
            </thead>
            <tbody id="tbod">
            </tbody>
        </table>
        </div>
    </div>

</div>

<div id="pg2">

    <br />

    <div class="sections">
        <label class="formt">Trailer ID:</label>
        <label id="NOPS"  style="color: red;">NOPS TRAILER</label>
        <input class="form2" id="trlr_id" type="text" list="trlr_data" oninput="NOPSFunc(document.getElementById('trlr_id').value)" onchange="oninput">
        <datalist id="trlr_data">
        </datalist>
    </div>
    <br />
    <div class="sections">
        <label class="formt">Loading Site:</label>
        <input class="form1" id="lded_site" type="text" list="lded_data">
        <datalist id="lded_data">
        </datalist>
    </div>

    <br />

    <div class="mySearch">
        <button class="return" type="button">Cancel</button>
        <button id="submit" type="button">Select Trailer Load</button>
    </div>

    <br />

</div>

<div id="pg3">

    <br />
    <div id="boxinput">
        <datalist id="lded_prd">
        </datalist>
        <datalist id="lded_des">
        </datalist>
    </div>

    <br />
    <div class="mySearch">
        <button class="return" type="button">Cancel</button>
        <button id="submit2" type="button">Submit</button>
    </div>

    <br />

</div>
  
<script type="text/javascript">  

    function is_valid_datalist_value(idDataList, inputValue) {
        var option = document.querySelector("#" + idDataList + " option[value='" + inputValue + "']");
        if (option != null) {
            return option.value.length > 0;
        }
        return false;
    }

    function NOPSFunc(trlr_num) {
        $('#NOPS').hide();
        if (document.getElementById("trlr_id").value == "") {
            $('#NOPS').hide();
        }
        else {
            $.getJSON(
                "/DesktopModules/HJLeaTrailerLoad/API/ModuleTask/GetTrailers/",
                function (result) {
                    var parsedtrlrJSONObject = jQuery.parseJSON(result);
                    $.each(parsedtrlrJSONObject, function () {
                        if (this.trlr_num == trlr_num) {                    
                            if (this.TNOPS == 1) {
                                $('#NOPS').show();
                            }
                            else {
                                $('#NOPS').hide();
                            }
                        }
                    });
                }
            )
        }
    };

    function getbox(ld, i) {
        $.getJSON(
            "/DesktopModules/HJLeaTrailerLoad/API/ModuleTask/GetBoxes/" + ld,
            function (result) {
                var parsedBoxJSONObject = jQuery.parseJSON(result);
                $.each(parsedBoxJSONObject, function () {
                    if (this.PNOPS == "Risk") {
                        $('#' + i + '').append(
                            '<tr>' +
                            '<td>' + this.bx_id + '</td>' +
                            '<td>' + this.lded_wth + '</td>' +
                            '<td>' + this.lded_desc + '</td>' +
                            '<td style="color:red;">' + this.PNOPS + '</td>' +
                            '<td>' + this.PG + '</td>' +
                            '</tr>'
                        );
                    }
                    else {
                        $('#' + i + '').append(
                            '<tr>' +
                            '<td>' + this.bx_id + '</td>' +
                            '<td>' + this.lded_wth + '</td>' +
                            '<td>' + this.lded_desc + '</td>' +
                            '<td>' + this.PNOPS + '</td>' +
                            '<td>' + this.PG + '</td>' +
                            '</tr>'
                        );
                    }
                });
            }
        );
    };

    $(document).ready(function () {

        //Load Data List info//
        $.getJSON(
            "/DesktopModules/HJLeaTrailerLoad/API/ModuleTask/GetTrailers/",
            function (result) {
                var parsedTrailerJSONObject = jQuery.parseJSON(result);
                $.each(parsedTrailerJSONObject, function () {
                    $('#trlr_data').append(
                        '<option value="' + this.trlr_num + '">'
                    );
                });
            }
        );

        $.getJSON(
            "/DesktopModules/HJLeaTrailerLoad/API/ModuleTask/GetSites/",
            function (result) {
                var parsedSitesJSONObject = jQuery.parseJSON(result);
                $.each(parsedSitesJSONObject, function () {
                    $('#lded_data').append(
                        '<option value="' + this.site_name + '">'
                    );
                });
            }
        );

        $('#loading').hide();
        $('#pg2').hide();
        $('#pg3').hide();
        $('.form1').val('');

        var moduleId = <%= ModuleId %>;
        var userID = <%= UserId %>;

        //Search for Trailer Loads Table//

        $('#tbod').on('click', '.reducer', function (e) {
            e.stopPropagation(); // Prevent event from propagating
            var target = $(this).data('target');
            if (!$(target).hasClass('in')) {
                $('.collapse').removeClass('in'); // Collapse all other rows
            }
            $(target).toggleClass('in'); // Toggle the clicked row
        });

        $('#myButton').click(function () {
            $('#tbod').children().remove();
            var input = $('#myInput').val();
            var i = '1'
            $.getJSON(
                "/DesktopModules/HJLeaTrailerLoad/API/ModuleTask/GetTasks/" + moduleId + "/" + input,
                function (result) {
                    var parsedTaskJSONObject = jQuery.parseJSON(result);
                    $.each(parsedTaskJSONObject, function () {
                        var newFormattedDate = new Date(this.lded_dte);
                        var newFormattedDate = newFormattedDate.toLocaleString();
                        var newFormattedDate = newFormattedDate.split(' ').slice(0, 4).join(' ');
                        i = i + '1'
                        $('#tbod').append(
                            '<tr class="reducer" style="cursor: pointer;" data-toggle="collapse" id="table' + i + '" data-target=".table' + i + '">' +
                            '<td>' + this.trlr_id + '</td>' +
                            '<td>' + this.TNOPS + '</td>' +
                            '<td>' + newFormattedDate + '</td>' +
                            '<td>' + this.lded_site + '</td>' +
                            '</tr>' +
                            '<tr class="collapse table' + i + '">' +
                            '<td colspan = "999" >' +
                            '<div>' +
                            '<table class="table table-striped" >'+
                            '<thead>' +
                            '<tr>' +
                            '<th>Compartment ID</th>' +
                            '<th>Loaded Product Code</th>' +
                            '<th>Loaded Product Description</th>' +
                            '<th>NOPS Risk</th>' +
                            '<th>Product Group</th>' +
                            '</tr>' +
                            '</thead>' +
                            '<tbody id="' + i + '">' +
                            '</tbody>' +
                            '</table>' +
                            '</div>' +
                            '</td >' +
                            '</tr >'
                        );

                        //Get query for box table info//
                        getbox(this.ld_id, i);

                    });  
                }
            );
        });


        // load pg2 //
        $('#addButton').click(function () {
            $('#pg1').hide();
            $('#NOPS').hide();
            $('form :input').val('');
            $('#tbod').children().remove();
            $('#pg2').show();
        });

        // load pg1 //
        $('.return').click(function () {
            $('#pg2').hide();
            $('#pg3').hide();
            $('.clearing').remove();
            $('form :input').val('');
            $('#tbod').children().remove();
            $('#pg1').show();
        });

        $('#submit').click(function () {
            $.when(primary()).then(secondary())
        });

        function primary() {
            if (is_valid_datalist_value('trlr_data', document.getElementById('trlr_id').value)) {
                if (is_valid_datalist_value('lded_data', document.getElementById('lded_site').value)) {

                    $('loading').show();
                    $('#pg2').hide();
                    $('#pg3').hide();

                    $.getJSON(
                        "/DesktopModules/HJLeaTrailerLoad/API/ModuleTask/GetProd/",
                        function (result) {
                            $.each(result, function () {
                                $('#lded_prd').append(
                                    '<option value="' + this.packageditemdescription + '">',
                                    '<option value="' + this.packageditemreference + '">'
                                );
                            });
                        }
                    );

                    //add a get request to find all boxes //
                    var trailer = $('#trlr_id').val();
                    $.getJSON(
                        "/DesktopModules/HJLeaTrailerLoad/API/ModuleTask/GetInfo/?trlr_id=" + trailer,
                        function (result) {
                            var parsedInfoJSONObject = jQuery.parseJSON(result);
                            var i = 0;
                            $.each(parsedInfoJSONObject, function () {
                                i = i + 1
                                $('#boxinput').append(
                                    '<div class ="clearing">' +
                                    '<div>' +
                                    '<h6>Compartment ' + i.toString() +
                                    '</div>' +
                                    '<input id= "Box' + i.toString() + '" class= "boxin" type = "text" list="lded_prd">' +
                                    '<br />' +
                                    '<label id= "Box' + i.toString() + 'C" class= "formt" >Product Code: </label >' +
                                    '<label id= "Box' + i.toString() + 'D" class= "formt" >Product Description: </label >' +
                                    '<label id= "Box' + i.toString() + 'R" class= "formt" >NOPS RISK: </label >' +
                                    '<label id= "Box' + i.toString() + 'P" class= "formt" >Product Group: </label >' +
                                    '<br />' +
                                    '</div>'
                                );
                            });
                        }
                    );

                } else {
                    alert("Invalid Site");
                }
            } else {
                alert("Invalid Trailer ID");
            }
        }

        function secondary() {
            $('loading').hide();
            $('#pg3').show();
        }

        $('#submit2').click(function () {

            //post trailer table//
            var TNOPS2 = ""

            var trlr_id = $('#trlr_id').val();

            $.getJSON(
                "/DesktopModules/HJLeaTrailerLoad/API/ModuleTask/GetTrailers/",
                function (result) {
                    var parsedtrlrJSONObject = jQuery.parseJSON(result);
                    $.each(parsedtrlrJSONObject, function () {
                        if (this.trlr_num == trlr_id) {
                            if (this.TNOPS == "1") {
                                TNOPS2 = "✔"
                            }
                            else {
                                TNOPS2 = "✘"
                            }
                        }
                    });

                    //format time//
                    const date = new Date(Date.now());

                    const formatOptions = {
                        timeZone: 'Europe/London',
                        dateStyle: 'short',
                        hour12: false,
                        timeStyle: 'medium'
                    };

                    var lded_dte = new Intl.DateTimeFormat('en-CA', formatOptions).format(date).split(',').join('');

                    //get lded site from input//
                    var lded_site = $('#lded_site').val();

                    //store of insert query data// 
                    var taskToCreate = {
                        TTC_trlr_id: trlr_id,
                        TTC_lded_dte: lded_dte,
                        TTC_lded_site: lded_site,
                        TTC_TNOPS: TNOPS2,
                        TTC_ModuleID: moduleId,
                        TTC_UserID: userID
                    };

                    //Module verification//
                    var sf = $.ServicesFramework(<%:ModuleContext.ModuleId%>);


                    var myVariable;

                    //send add request//
                    $.ajax({
                        url: "/DesktopModules/HJLeaTrailerLoad/API/ModuleTask/AddTask",
                        type: "POST",
                        contentType: "application/json;charset=utf-8",
                        data: JSON.stringify(taskToCreate),
                        async: false,
                        beforeSend: sf.setModuleHeaders,
                        success: function (data) {
                            myVariable = data;
                        }
                    });

                    //post box table//
                    var box_id_i = 0
                    $(".boxin").each(function () {
                        box_id_i = box_id_i + 1
                        var load = $('#Box' + box_id_i.toString() + 'C')
                        var loadedwith = load.text()
                        loadedwith = loadedwith.replace('Product Code: ', '');
                        var load2 = $('#Box' + box_id_i.toString() + 'D')
                        var loadeddesc = load2.text()
                        loadeddesc = loadeddesc.replace('Product Description: ', '');
                        var NOPS = $('#Box' + box_id_i.toString() + 'R')
                        var PNOPS = NOPS.text()
                        var PNOPS = PNOPS.replace('NOPS RISK: ', '');
                        var PG2 = $('#Box' + box_id_i.toString() + 'P')
                        var PG = PG2.text()
                        PG = PG.replace('Product Group: ', '');
                        var ld_id = myVariable

                        var boxToCreate = {
                            BTC_bx_id: box_id_i,
                            BTC_lded_wth: loadedwith,
                            BTC_lded_desc: loadeddesc,
                            BTC_PNOPS: PNOPS,
                            BTC_ld_id: ld_id,
                            BTC_PG: PG
                        };

                        $.ajax({
                            url: "/DesktopModules/HJLeaTrailerLoad/API/ModuleTask/AddBox",
                            type: "POST",
                            contentType: "application/json;charset=utf-8",
                            data: JSON.stringify(boxToCreate),
                            async: false,
                            beforeSend: sf.setModuleHeaders
                        });

                    });



                    //return to pg1//
                    $('#pg2').hide();
                    $('#pg3').hide();
                    $('.clearing').remove();
                    $('form :input').val('');
                    $('#tbod').children().remove();
                    $('#pg1').show();

                }
            )

        });

        $(document).on('change textInput input', '.boxin', function () {
            var value = $(this).val();
            var id = $(this).attr('id');
            if (value === "") {
                $('#' + id + 'C').text("Product Code: ");
                $('#' + id + 'D').text("Product Description: ");
                $('#' + id + 'R').text("NOPS RISK: ");
                $('#' + id + 'R').css('color', '#33335A');
                $('#' + id + 'P').text("Product Group: ");
            }
            else {
                $.getJSON(
                    "/DesktopModules/HJLeaTrailerLoad/API/ModuleTask/GetID?packageditemreference=" + value,
                    function (result) {
                        if (result.length > 0) {
                            $.each(result, function () {
                                $('#' + id + 'C').text("Product Code: " + this.packageditemreference);
                                $('#' + id + 'D').text("Product Description: " + this.packageditemdescription);
                                if (this.subgroupdescription == "Dry Bulk" || this.subgroupdescription == "Wet Bulk" || this.subgroupdescription == "Minerals & Supplements") {
                                    $('#' + id + 'P').text("Product Group: Raw Material");
                                }
                                else {
                                    $('#' + id + 'P').text("Product Group: " + this.subgroupdescription);
                                }

                                $.getJSON(
                                    "/DesktopModules/HJLeaTrailerLoad/API/ModuleTask/GetNOPS?packageditemreference=" + this.packageditemreference,
                                    function (result) {
                                        result2 = JSON.parse(result)
                                        if (result2.length > 0) {
                                            if (result2[0].PNOPS == "1") {
                                                $('#' + id + 'R').text("NOPS RISK: Risk");
                                                $('#' + id + 'R').css('color', 'red');
                                            }
                                            else {
                                                $('#' + id + 'R').text("NOPS RISK: No Risk");
                                                $('#' + id + 'R').css('color', '#33335A');
                                            }
                                        }
                                        else {
                                            $('#' + id + 'R').text("NOPS RISK: No Risk");
                                            $('#' + id + 'R').css('color', '#33335A');
                                        }
                                    }
                                )
                            })
                        }
                        else {
                            $.getJSON(
                                "/DesktopModules/HJLeaTrailerLoad/API/ModuleTask/GetDes?packageditemdescription=" + value,
                                function (result) {
                                    $.each(result, function () {
                                        $('#' + id + 'C').text("Product Code: " + this.packageditemreference);
                                        $('#' + id + 'D').text("Product Description: " + this.packageditemdescription);
                                        if (this.subgroupdescription == "Dry Bulk" || this.subgroupdescription == "Wet Bulk" || this.subgroupdescription == "Minerals & Supplements") {
                                            $('#' + id + 'P').text("Product Group: Raw Material");
                                        }
                                        else {
                                            $('#' + id + 'P').text("Product Group: " + this.subgroupdescription);
                                        }

                                        $.getJSON(
                                            "/DesktopModules/HJLeaTrailerLoad/API/ModuleTask/GetNOPS?packageditemreference=" + this.packageditemreference,
                                            function (result) {
                                                result2 = JSON.parse(result)
                                                if (result2.length > 0) { 
                                                    if (result2[0].PNOPS == "1") {
                                                        $('#' + id + 'R').text("NOPS RISK: Risk");
                                                        $('#' + id + 'R').css('color', 'red');
                                                    }
                                                    else {
                                                        $('#' + id + 'R').text("NOPS RISK: No Risk");
                                                        $('#' + id + 'R').css('color', '#33335A');
                                                    }
                                                }
                                                else {
                                                    $('#' + id + 'R').text("NOPS RISK: No Risk");
                                                    $('#' + id + 'R').css('color', '#33335A');
                                                }
                                            }
                                        )
                                    })
                                }
                            )
                        }
                    }
                );
            }
        });

    });

</script>