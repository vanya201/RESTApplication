<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="ISO-8859-1">
    <title>Product Page</title>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.0/jquery.min.js"></script>
    <script type="text/javascript">

        var sellers = []
        jQuery(document).ready(function() {

            refreshProductList();
            refreshSellerList();

            jQuery("#addproduct").click(function() {
                var sellerId = jQuery("#sellerId").val();
                var seller = {
                    id: sellerId
                };
                var url = 'rest/product/addProduct';

                jQuery.ajax({
                    url: url,
                    type: 'POST',
                    contentType: 'application/json',
                    data: JSON.stringify({
                        name: jQuery("#productname").val(),
                        description: jQuery("#productdescription").val(),
                        seller: { id: sellerId }
                    }),
                    success: function(data) {

                        refreshProductList();

                        jQuery("#productname").val('');
                        jQuery("#productdescription").val('');
                        jQuery("#sellerId").val('');
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
                    tableContent += "<td>" + data[key].description + "</td>";
                    tableContent += "<td>" + (data[key].seller && data[key].seller.name ? data[key].seller.name : 'Unknown Seller') + "</td>";
                    tableContent += "<td>" +
                        "<input type='button' onclick='deleteProduct(" + data[key].id + ")' value='Delete product'/>" +
                        "<input type='button' onclick='editProduct(this)' value='Edit product'/>" +
                        "</td>";
                    tableContent += "</tr>";
                }
            }
            return tableContent;
        }

        function refreshProductList() {
            jQuery.ajax({
                url: 'rest/product/getAllProducts',
                dataType: 'json',
                type: 'GET',
                success: function(data) {
                    jQuery('.datarow').remove();
                    jQuery('#headerrow').after(createDataRowsFromJson(data));
                }
            });
        }

        function refreshSellerList() {
            jQuery.ajax({
                url: 'rest/seller/getAllSellers',
                dataType: 'json',
                type: 'GET',
                success: function(data) {
                    var sellerSelect = jQuery("#sellerId");
                    sellerSelect.empty();
                    sellers.push("<option value=''>Select a seller</option>");
                    sellerSelect.append("<option value=''>Select a seller</option>");

                    jQuery.each(data, function(index, seller) {
                        sellerSelect.append("<option value='" + seller.id + "'>" + seller.name + "</option>");
                        sellers.push("<option value='" + seller.id + "'>" + seller.name + "</option>");
                    });
                }
            });
        }

        function deleteProduct(id) {
            var url = 'rest/product/deleteProduct/' + id;

            jQuery.ajax({
                url: url,
                dataType: 'json',
                type: 'DELETE',
                success: function(data) {
                    // ????????? ?????? ????????? ????? ????????
                    refreshProductList();
                }
            });
        }


        function editProduct(button) {
            var row = jQuery(button).closest('tr');

            row.data('originalId', row.find('td:eq(0)').text());
            row.data('originalName', row.find('td:eq(1)').text());
            row.data('originalDescription', row.find('td:eq(2)').text());
            row.data('originalSeller', row.find('td:eq(3)').text());

            row.children().each(function(index, value) {
                if (index == 1) {
                    jQuery(this).html("<input type='text' id='editname' value='" + jQuery(this).text() + "'/>");
                } else if (index == 2) {
                    jQuery(this).html("<input type='text' id='editdescription' value='" + jQuery(this).text() + "'/>");
                } else if (index == 3) {
                    var sellerSelect = "<select id='editsellerid'>";
                    for(var seller of sellers)
                        sellerSelect += seller;

                    sellerSelect += "</select>";
                    jQuery(this).html(sellerSelect);
                } else if (index == 4) {
                    var actionHtml = "<input type='button' onclick='applyEditProduct(this)' value='Update product'/>" +
                        "<input type='button' onclick='cancelEdit(this)' value='Cancel edit'/>";
                    jQuery(this).html(actionHtml);
                }
            });
        }


        function cancelEdit(button) {
            var row = jQuery(button).closest('tr');

            var originalId = row.data('originalId');
            var originalName = row.data('originalName');
            var originalDescription = row.data('originalDescription');
            var originalSeller = row.data('originalSeller');

            row.children().each(function(index, value) {
                if (index == 0) {
                    jQuery(this).text(originalId);
                } else if (index == 1) {
                    jQuery(this).text(originalName);
                } else if (index == 2) {
                    jQuery(this).text(originalDescription);
                } else if (index == 3) {
                    jQuery(this).text(originalSeller);
                } else if (index == 4) {
                    var actionHtml = "<input type='button' onclick='deleteProduct(" + originalId + ")' value='Delete product'/>" +
                        "<input type='button' onclick='editProduct(this)' value='Edit product'/>";
                    jQuery(this).html(actionHtml);
                }
            });
        }


        function applyEditProduct(button) {
            var id, name, description, sellerId;
            var row = jQuery(button).closest('tr');
            row.children().each(function(index, value) {
                if (index == 0) {
                    id = jQuery(this).text();
                } else if (index == 1) {
                    name = jQuery(this).find('input').val();
                } else if (index == 2) {
                    description = jQuery(this).find('input').val();
                } else if (index == 3) {
                    sellerId = jQuery(this).find('select').val();
                }
            });


            var url = 'rest/product/updateProduct';
            jQuery.ajax({
                url: url,
                contentType: 'application/json',
                data: JSON.stringify({
                    id :id,
                    name:name,
                    description: description,
                    seller: { id: sellerId }
                }),
                type: 'PUT',
                success: function(data) {
                    refreshProductList();
                }
            });
        }
    </script>
</head>
<body>
<h1>Product page</h1>
<table style="width: 100%" border="1" id="producttable">
    <tr id="headerrow">
        <td>Id</td>
        <td>Name</td>
        <td>Description</td>
        <td>Seller</td>
        <td>Action</td>
    </tr>
    <tr>
        <td></td>
        <td><input type="text" name="productname" id="productname" /></td>
        <td><input type="text" name="productdescription" id="productdescription" /></td>
        <td>
            <select name="sellerId" id="sellerId">
                <option value="">Select a seller</option>
            </select>
        </td>
        <td><input type="button" name="addproduct" id="addproduct" value="Add product"></td>
    </tr>
</table>
<div style="margin-top: 20px;">
    <button onclick="window.location.href='product.jsp'">Product Page</button>
    <button onclick="window.location.href='seller.jsp'">Seller Page</button>
</div>
</body>
</html>
