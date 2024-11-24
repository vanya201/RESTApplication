package ua.cn.stu.services;

import stu.cn.ua.dao.HibernateDAOFactory;
import stu.cn.ua.dao.ProductDAO;
import stu.cn.ua.domain.Product;

import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import java.util.List;

@Path("product")
public class ProductService {
    private final ProductDAO productDAO = HibernateDAOFactory.getInstance().getProductDAO();

    @GET
    @Path("getAllProducts")
    @Produces(MediaType.APPLICATION_JSON)
    public List<Product> getAllProducts() {
        return productDAO.getAllEntities();
    }

    @POST
    @Path("addProduct")
    @Consumes(MediaType.APPLICATION_JSON)
    public Response addProduct(Product product) {
        productDAO.createEntity(product);
        return Response.status(Response.Status.CREATED).build();
    }

    @DELETE
    @Path("deleteProduct/{productid}")
    public void deleteProduct(@PathParam("productid") Long productid) {
        productDAO.deleteEntityById(productid);
    }

    @PUT
    @Path("updateProduct")
    @Consumes(MediaType.APPLICATION_JSON)
    public Response updateProduct(Product product) {
        productDAO.updateEntity(product);
        return Response.ok().build();
    }
}
