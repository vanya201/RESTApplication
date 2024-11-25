package ua.cn.stu.services;

import stu.cn.ua.dao.HibernateDAOFactory;
import stu.cn.ua.dao.SellerDAO;
import stu.cn.ua.domain.Seller;

import javax.validation.Valid;
import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import javax.validation.Validator;
import javax.validation.Validation;
import javax.validation.ConstraintViolation;
import java.util.List;
import java.util.Set;

@Path("seller")
public class SellerService {
    private final SellerDAO sellerDAO = HibernateDAOFactory.getInstance().getSellerDAO();
    private final Validator validator = Validation.buildDefaultValidatorFactory().getValidator();

    @GET
    @Path("getAllSellers")
    @Produces(MediaType.APPLICATION_JSON)
    public List<Seller> getAllSellers() {
        return sellerDAO.getAllEntities();
    }

    @POST
    @Path("addSeller")
    @Consumes(MediaType.APPLICATION_JSON)
    public Response addSeller(@Valid Seller seller) {
        Set<ConstraintViolation<Seller>> violations = validator.validate(seller);
        if (!violations.isEmpty())
            return Response.status(Response.Status.BAD_REQUEST).build();
        sellerDAO.createEntity(seller);
        return Response.status(Response.Status.CREATED).build();
    }

    @DELETE
    @Path("deleteSeller/{sellerid}")
    public Response deleteSeller(@PathParam("sellerid") Long sellerid) {
        sellerDAO.deleteEntityById(sellerid);
        return Response.ok().build();
    }

    @PUT
    @Path("updateSeller")
    @Consumes(MediaType.APPLICATION_JSON)
    public Response updateSeller(@Valid Seller seller) {
        Set<ConstraintViolation<Seller>> violations = validator.validate(seller);
        if (!violations.isEmpty())
            return Response.status(Response.Status.BAD_REQUEST).build();
        sellerDAO.updateEntity(seller);
        return Response.ok().build();
    }
}
