package ua.cn.stu.services;

import stu.cn.ua.dao.HibernateDAOFactory;
import stu.cn.ua.dao.SellerDAO;
import stu.cn.ua.domain.Seller;

import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import java.util.List;

@Path("seller")
public class SellerService {
    private final SellerDAO sellerDAO = HibernateDAOFactory.getInstance().getSellerDAO();

    @GET
    @Path("getAllSellers")
    @Produces(MediaType.APPLICATION_JSON)
    public List<Seller> getAllSellers() {
        return sellerDAO.getAllEntities();
    }

    @POST
    @Path("addSeller")
    @Consumes(MediaType.APPLICATION_JSON)
    public Response addseller(Seller seller) {
        sellerDAO.createEntity(seller);
        return Response.status(Response.Status.CREATED).build();
    }

    @DELETE
    @Path("deleteSeller/{sellerid}")
    public void deleteSeller(@PathParam("sellerid") Long sellerid) {
        sellerDAO.deleteEntityById(sellerid);
    }

    @PUT
    @Path("updateSeller")
    @Consumes(MediaType.APPLICATION_JSON)
    public Response updateSeller(Seller seller) {
        sellerDAO.updateEntity(seller);
        return Response.ok().build();
    }
}
