<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="ISO-8859-1">
    <title>Seller Page</title>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.0/jquery.min.js"></script>
    <script type="text/javascript">
        jQuery(document).ready(function() {

            jQuery.ajax({
                url: 'rest/seller/getAllSellers',
                dataType: 'json',
                type: 'GET',
                success: function(data) {
                    jQuery('#headerrow').after(createDataRowsFromJson(data));
                }
            });

            jQuery("#addseller").click(function() {
                var url = 'rest/seller/addSeller';
                var sellerData = JSON.stringify({
                    name: jQuery("#sellername").val(),
                    email: jQuery("#selleremail").val()
                });

                jQuery.ajax({
                    url: url,
                    data: sellerData,
                    contentType: 'application/json',
                    type: 'POST',
                    success: function() {

                        jQuery.ajax({
                            url: 'rest/seller/getAllSellers',
                            dataType: 'json',
                            type: 'GET',
                            success: function(data) {
                                jQuery('.datarow').remove();
                                jQuery('#headerrow').after(createDataRowsFromJson(data));
                                jQuery("#sellername").val('');
                                jQuery("#selleremail").val('');
                            }
                        });
                    }
                });
            });
        });

        function createDataRowsFromJson(data) {
            var tableContent = "";
            for (var key in data) {
                if (data.hasOwnProperty(key)) {
                    tableContent += "<tr class='datarow'>";
                    tableContent += "<td>" + data[key].id + "</td>";
                    tableContent += "<td>" + data[key].name + "</td>";
                    tableContent += "<td>" + data[key].email + "</td>";
                    tableContent += "<td>";
                    tableContent += "<input type='button' onclick='deleteSeller(" + data[key].id + ")' value='Delete Seller'/>";
                    tableContent += "<input type='button' onclick='editSeller(this)' value='Edit Seller'/>";
                    tableContent += "</td>";
                    tableContent += "</tr>";
                }
            }
            return tableContent;
        }

        function deleteSeller(id) {
            var url = 'rest/seller/deleteSeller/' + id;

            jQuery.ajax({
                url: url,
                type: 'DELETE',
                success: function() {
                    jQuery.ajax({
                        url: 'rest/seller/getAllSellers',
                        dataType: 'json',
                        type: 'GET',
                        success: function(data) {
                            jQuery('.datarow').remove();
                            jQuery('#headerrow').after(createDataRowsFromJson(data));
                        }
                    });
                }
            });
        }

        function editSeller(button) {
            jQuery(button).closest('tr').children().each(function(index, value) {
                if (index == 1) {
                    jQuery(this).html("<input type='text' id='editname' value='" + jQuery(this).text() + "'/>");
                } else if (index == 2) {
                    jQuery(this).html("<input type='text' id='editemail' value='" + jQuery(this).text() + "'/>");
                } else if (index == 3) {
                    var actionHtml = "<input type='button' onclick='applyEditSeller(this)' value='Update Seller'/>";
                    actionHtml += "<input type='button' onclick='cancelEdit(this)' value='Cancel Edit'/>";
                    jQuery(this).html(actionHtml);
                }
            });
        }

        function cancelEdit(button) {
            var id;
            jQuery(button).closest('tr').children().each(function(index, value) {
                if (index == 0) {
                    id = jQuery(this).text();
                } else if (index != 0 && index != 3) {
                    jQuery(this).html(jQuery(this).find('input').val());
                } else if (index == 3) {
                    var actionHtml = "<input type='button' onclick='deleteSeller(" + id + ")' value='Delete Seller'/>";
                    actionHtml += "<input type='button' onclick='editSeller(this)' value='Edit Seller'/>";
                    jQuery(this).html(actionHtml);
                }
            });
        }

        function applyEditSeller(button) {
            var id, name, email;
            jQuery(button).closest('tr').children().each(function(index, value) {
                if (index == 0) {
                    id = jQuery(this).text();
                } else if (index == 1) {
                    name = jQuery(this).find('input').val();
                } else if (index == 2) {
                    email = jQuery(this).find('input').val();
                }
            });

            var url = 'rest/seller/updateSeller';
            var sellerData = JSON.stringify({
                id: id,
                name: name,
                email: email
            });

            jQuery.ajax({
                url: url,
                data: sellerData,
                contentType: 'application/json',
                type: 'PUT',
                success: function() {
                    jQuery.ajax({
                        url: 'rest/seller/getAllSellers',
                        dataType: 'json',
                        type: 'GET',
                        success: function(data) {
                            jQuery('.datarow').remove();
                            jQuery('#headerrow').after(createDataRowsFromJson(data));
                        }
                    });
                }
            });
        }
    </script>
</head>
<body>
<h1>Seller Page</h1>
<table style="width: 100%" border="1" id="sellertable">
    <tr id="headerrow">
        <td>Id</td>
        <td>Name</td>
        <td>Email</td>
        <td>Action</td>
    </tr>
    <tr>
        <td></td>
        <td><input type="text" name="sellername" id="sellername" /></td>
        <td><input type="text" name="selleremail" id="selleremail" /></td>
        <td><input type="button" name="addseller" id="addseller" value="Add Seller"></td>
    </tr>
</table>
<div style="margin-top: 20px;">
    <button onclick="window.location.href='product.jsp'">Product Page</button>
    <button onclick="window.location.href='seller.jsp'">Seller Page</button>
</div>
</body>
</html>

