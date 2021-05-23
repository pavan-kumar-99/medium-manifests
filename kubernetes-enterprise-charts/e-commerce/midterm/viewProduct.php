<?php
require_once("include/initialize.php");

    if(isset($_POST['close'])=='close'){
            unset($_SESSION['PROID']);
          // echo "<script> alert('get');</script>";
          redirect(web_root.'index.php'); 
          }

          if (isset($_POST['PROID'])){
          $_SESSION['PROID'] = $_POST['PROID'];
        }

   

       // $PROID =   $_POST['id']; 
       $query = "SELECT * FROM `tblproduct` p  ,`tblcategory` c 
                WHERE   p.`CATEGID`=c.`CATEGID` AND `PROID`=" . $_SESSION['PROID'] ;
        $mydb->setQuery($query);
        $cur = $mydb->loadSingleResult();

             
      ?> 

	  
 <div class="modal-dialog"  style="width:50%">
  <div class="modal-content">   
    <button class="close" data-dismiss="modal" type="button">×</button> 
       <form  method="POST" action="cart/controller.php?action=add">
     <div class="modal-body">  
              <div class="row">  
                <div class="col-md-6">
                  <img width="230" class="" height="220"  src="<?php echo web_root . 'admin/products/'.  $cur->IMAGES;?>" alt="">
                </div>

     
                <div class="col-md-6">
                    <input type="hidden" name="PROPRICE" value="<?php  echo $cur->PROPRICE; ?>">
                    <input type="hidden" id="PROQTY" name="PROQTY" value="<?php  echo $cur->PROQTY; ?>">

                    <input type="hidden" name="PROID" value="<?php  echo $cur->PROID; ?>">
                    <h1><?php echo $cur->PRONAME ; ?></h1>
                    <p><b>Category:</b><?php echo   $cur->CATEGORIES;?></p>
					<ul>
						<li>Price - &#8369 <?php echo $cur->PROPRICE; ?></li>
					</ul>
					<hr/>
                    <h4>Product Details</h4>
					<hr/>
                    <ul>
						
						
						
						<li><b>Model : </b><?php echo $cur->PROMODEL; ?></li>
						<li><b>Type : </b><?php echo $cur->PRODESC; ?></li>
						<li><b>In Stock :</b><font color="red"> <?php echo $cur->PROQTY; ?></li></font>
					  
                    </ul> 
                    <button class="btn btn-primary"  name="btnorder" type="Submit" >Add to Cart!</button> 
                    <button class="btn btn-danger" id="btn_close" data-dismiss="modal" type="button">Close</button> 

                </div>
              
            
            </div> 
         </div> 
        </form> 
       </div> 
  </div> 