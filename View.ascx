<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="View.ascx.cs" Inherits="Morningfoods.Modules.HJLeaTrailerLoad.View" %>

<br />
<h4>Trailer History</h4>

<div id="pg1">
    <br />
    <div class="mySearch">
        <input type="text" id="myInput" placeholder="Search for a Trailer ID" title="Type in a name">
        <button id="myButton" type="button">Search</button>
        <button id="addButton" type="button">New Trailer Load</button>
    </div>

    <br />
    
    <table id = 'myTable'>
        <tr>
            <th>Trailer ID</th>
            <th>Loaded With</th>
            <th>Date Loaded</th>
            <th>Site Loaded</th>
        </tr>
    </table>
</div>

<div id="pg2">

    <br />

    <div class="containers">
        <label class="formt">Trailer ID:</label>
        <input class="form1" id="trlr_id" type="text" >
    </div>
    <br />
    <div class="containers">
        <label class="formt">Loading With:</label>
        <input class="form1" id="lded_wth" type="text" >
    </div>
    <br />
    <div class="containers">
        <label class="formt">Loading Site:</label>
        <input class="form1" id="lded_site" type="text" >
    </div>

    <br />

    <div class="mySearch">
        <button id="return" type="button">Return</button>
        <button id="submit" type="button">Submit Trailer Load</button>
    </div>

    <br />

</div>

<script type="text/javascript">

    $(document).ready(function () {

        $('#pg2').hide();
        $('.form1').val('');

        var moduleId = <%= ModuleId %>;

        $('#myButton').click(function () {
            $('#myTable td').parent().remove();
            var input = $('#myInput').val();
            $.getJSON(
                "/DesktopModules/HJLeaTrailerLoad/API/ModuleTask/GetTasks/" + moduleId + "/" + input,
                function (result) {
                    var parsedTaskJSONObject = jQuery.parseJSON(result);
                    $.each(parsedTaskJSONObject, function () {
                        var newFormattedDate = new Date(this.lded_dte);
                        var newFormattedDate = newFormattedDate.toLocaleString();
                        var newFormattedDate = newFormattedDate.split(' ').slice(0, 4).join(' ');
                        $('#myTable').append(
                            '<tr>' +
                            '<td>' + this.trlr_id + '</td>' +
                            '<td>' + this.lded_wth + '</td>' +
                            '<td>' + newFormattedDate + '</td>' +
                            '<td>' + this.lded_site + '</td>' +
                            '<tr />'
                        );
                    }
                    );
                }
            );
        });

        $('#addButton').click(function () {
            $('#pg1').hide();
            $('form :input').val('');
            $('#myTable td').parent().remove();
            $('#pg2').show();
        });

        $('#return').click(function () {
            $('#pg2').hide();
            $('form :input').val('');
            $('#myTable td').parent().remove();
            $('#pg1').show();
        });

        var userID = <%= UserId %>;
        $('#submit').click(function () {
            var trlr_id = $('#trlr_id').val();
            var lded_wth = $('#lded_wth').val();
            const date = new Date(Date.now());

            const formatOptions = {
                timeZone: 'Europe/London',
                dateStyle: 'short',
                hour12: false,
                timeStyle: 'medium'
            };

            var lded_dte = new Intl.DateTimeFormat('en-CA', formatOptions).format(date).split(',').join('');
            var lded_site = $('#lded_site').val();
            console.log(lded_dte);

            var taskToCreate = {
                TTC_trlr_id: trlr_id,
                TTC_lded_wth: lded_wth,
                TTC_lded_dte: lded_dte,
                TTC_lded_site: lded_site,
                TTC_ModuleID: moduleId,
                TTC_UserID: userID
            };

            var sf = $.ServicesFramework(<%:ModuleContext.ModuleId%>);

            $.ajax({
            url: "/DesktopModules/HJLeaTrailerLoad/API/ModuleTask/AddTask",
            type: "POST",
            contentType: "application/json;charset=utf-8",
            data: JSON.stringify(taskToCreate),
            beforeSend: sf.setModuleHeaders
            });

            $('#pg2').hide();
            $('form :input').val('');
            $('#myTable td').parent().remove();
            $('#pg1').show();

        });

    });

</script>