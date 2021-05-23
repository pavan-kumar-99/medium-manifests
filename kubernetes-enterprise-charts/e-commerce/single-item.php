

<?php 
 $PROID =   $_GET['id']; 
$query = "SELECT * FROM `tblproduct` p  ,`tblcategory` c 
            WHERE   p.`CATEGID`=c.`CATEGID` AND p.`PROID`=" . $PROID;
            $mydb->setQuery($query);
            $cur = $mydb->loadResultList();


  foreach ($cur as $result) { 
   
?>
        <!-- Page Heading/Breadcrumbs -->
<!--         <div class="row">
            <div class="col-lg-12">
                <h1 class="page-header">Portfolio Item
                    <small>Subheading</small>
                </h1>
                <ol class="breadcrumb">
                    <li><a href="index.html">Home</a>
                    </li>
                    <li class="active">Portfolio Item</li>
                </ol>
            </div>
        </div> -->
        <!-- /.row -->

        <!-- Portfolio Item Row -->
   <form   method="POST" action="cart/controller.php?action=add">
        
        <div class="row">

            <div class="col-md-8">
            <div class="row">
                <div class="col-m-12">
                    <div class="col-md-8 responsive">
                          <img width="402" class="img-portfolio " height="300"  src="<?php echo web_root . 'admin/products/'.  $result->IMAGES;?>" alt="">
               
                    </div>
                    </div>
                
            </div>
            
      <!--           <div id="carousel-example-generic" class="carousel slide" data-ride="carousel">
                    Indicators -->
                  <!--   <ol class="carousel-indicators">
                        <li data-target="#carousel-example-generic" data-slide-to="0" class="active"></li>
                        <li data-target="#carousel-example-generic" data-slide-to="1"></li>
                        <li data-target="#carousel-example-generic" data-slide-to="2"></li>
                    </ol> -->
 
                    <!-- Wrapper for slides -->
                <!--     <div class="carousel-inner">
                        <div class="item active">
                            <img class="img-responsive" src="http://placehold.it/750x500" alt="">
                        </div>
                        <div class="item">
                            <img class="img-responsive" src="http://placehold.it/750x500" alt="">
                        </div>
                        <div class="item">
                            <img class="img-responsive" src="http://placehold.it/750x500" alt="">
                        </div>
                    </div> -->

                    <!-- Controls -->
                  <!--   
                    <a class="left carousel-control" href="#carousel-example-generic" data-slide="prev">
                        <span class="glyphicon glyphicon-chevron-left"></span>
                    </a>
                    <a class="right carousel-control" href="#carousel-example-generic" data-slide="next">
                        <span class="glyphicon glyphicon-chevron-right"></span>
                    </a>
                </div> -->
            </div>

     
            <div class="col-md-4">
              <input type="hidden" name="PROPRICE" value="<?php  echo $result->PROPRICE; ?>">
              <input type="hidden" id="PROQTY" name="PROQTY" value="<?php  echo $result->PROQTY; ?>">

              <input type="hidden" name="PROID" value="<?php  echo $result->PROID; ?>">
                <h1><?php echo $result->PRONAME ; ?></h1>
                    <p><b>Category:</b><?php echo   $result->CATEGORIES;?></p>
					<ul>
						<li>Price - &#8369 <?php echo $result->PROPRICE; ?></li>
					</ul>
					<hr/>
                    <h4>Product Details</h4>
					<hr/>
                    <ul>
						
						
						
						<li>Model - <?php echo $result->PROMODEL; ?></li>
						<li>Type - <?php echo $result->PRODESC; ?></li>
						<li>In Stock -<font color="red"> <?php echo $result->PROQTY; ?></li></font>
					  
                    </ul> 

                 <button  type="submit"  class="btn btn-primary btn-sm"  name="btnorder">Add to Cart</button>
            </div>
<?php } ?>       
        </div>
        <!-- /.row -->
</form>

<?php 
$query = "SELECT * FROM `tblproduct` WHERE `PRONAME`='" . $result->PRONAME . "' limit 4";
            $mydb->setQuery($query);
            $cur = $mydb->loadResultList(); 
?>
        <!-- Related Projects Row -->
        <div class="row">

            <div class="col-lg-12">
                <h3 class="page-header">Related Products</h3>
            </div>
<?php

  foreach ($cur as $result) { 

?>
            <div class="col-sm-3 col-xs-6">
                <a href="index.php?q=single-item&id=<?php echo $result->PROID; ?>">
                    <img class="img-hover img-related" width="135px" height="90px"  src="<?php echo web_root.'admin/products/'.$result->IMAGES;?>" alt="">
                </a><br/>
               <a href="index.php?q=single-item&id=<?php echo $result->PROID; ?>"><b><?php echo  $result->PRONAME . ' <br/>Model: '.$result->PROMODEL; ?></b></a>
            </div>

<?php } ?>
<!-- 
            <div class="col-sm-3 col-xs-6">
                <a href="#">
                    <img class="img-responsive img-hover img-related" src="http://placehold.it/500x300" alt="">
                </a>
            </div>

            <div class="col-sm-3 col-xs-6">
                <a href="#">
                    <img class="img-responsive img-hover img-related" src="http://placehold.it/500x300" alt="">
                </a>
            </div>

            <div class="col-sm-3 col-xs-6">
                <a href="#">
                    <img class="img-responsive img-hover img-related" src="http://placehold.it/500x300" alt="">
                </a>
            </div> -->

        </div>