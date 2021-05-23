
 
<?php  

  // if (!isset($_SESSION['USERID'])){
  //     redirect("index.php"); 
check_message();  
 
?>
               
                    <div class="table-responsive"  >
                    <div class="cartLi"> 

                         <table  class="table table-default" id="table" >
                         <thead> 
                             <td  ><b>Product</b></td>
                             <td ><b>Description</td>
                             <td  width="15%" ><b>Price</b</td>
                             <td  width="15%" ><b>Quantity</b</td> 
                             <td  width="15%" ><b>Total</b</td>  
                         </thead>  
                          
                             <?php



                              if (!empty($_SESSION['gcCart'])){ 

                                echo '<script>totalprice()</script>';

                                  $count_cart = count($_SESSION['gcCart']);

                                for ($i=0; $i < $count_cart  ; $i++) { 
 
                                       $query = "SELECT * FROM tblproduct p, tblcategory c 
                                      WHERE c.`CATEGID`=p.`CATEGID` and `PROID` = '".$_SESSION['gcCart'][$i]['productid']."'";
                                       $mydb->setQuery($query);
                                      $cur = $mydb->loadResultList();
                                
                                
                                 foreach ($cur as $result) {

                                ?>
                                <tr>
                                	<td>  
                                	  <img src="<?php echo web_root. 'admin/products/'.$result->IMAGES; ?>"  onload="  totalprice() " width="50px" height="50px">   
                              		</td>
                              		<td>  
                              			<?php echo  $result->PROMODEL   . ' <br/> ' .  $result->PRONAME . ' <br/> '.  $result->PRODESC ; ?>
                              		</td>
                              		<td>
                                    <input type="hidden"    id ="PROPRICE<?php echo $result->PROID;  ?>" name="PROPRICE<?php echo $result->PROID; ?>" value="<?php echo  $result->PROPRICE ; ?>" >
                                     
                              		&#8369	<?php echo  $result->PROPRICE ; ?>
                              		</td>
                              		<td class="input-group custom-search-form" >
                                       <input type="hidden" maxlength="3" class="form-control input-sm"  autocomplete="off"  id ="ORIGQTY<?php echo $result->PROID;  ?>" name="ORIGQTY<?php echo $result->PROID; ?>" value="<?php echo $result->PROQTY; ?>"   placeholder="Search for...">
                                        
                                        <input type="number" maxlength="3" data-id="<?php echo $result->PROID;  ?>" class="QTY form-control input-sm"  autocomplete="off"  id ="QTY<?php echo $result->PROID;  ?>" name="QTY<?php echo $result->PROID; ?>" value="<?php echo $_SESSION['gcCart'][$i]['qty']; ?>"   placeholder="Search for...">
                                        <span class="input-group-btn">
                                                <a title="Remove Item"  class="btn btn-danger btn-sm" id="btnsearch" name="btnsearch" href="cart/controller.php?action=delete&id=<?php echo $result->PROID; ?>">
                                                <i class="fa fa-trash-o"></i>
                                            </a>
                                        </span>
                                        </td>
                                      
                                        <input type="hidden"    id ="TOT<?php echo $result->PROID;  ?>" name="TOT<?php echo $result->PROID; ?>" value="<?php echo  $result->PROPRICE ; ?>" >
                                   
                                     <td> &#8369 <output id="Osubtot<?php echo $result->PROID ?>"><?php echo   $_SESSION['gcCart'][$i]['price'] ; ?></output></td>
                                </tr>
         
                            <?php  
                                 }
                               }
                               }else{ 
                                  echo "<h1>There is no item in the cart.</h1>";
                               } 
                            ?>  
                            
                      </table> 


                        <h3 align="right"> Total : &#8369<span id="sum">0</span></h3> </td>  
                    
<!-- 
                <a href="index.php?q=product" class="btn btn-default pull-left btn-sm"><span class="glyphicon glyphicon-arrow-left"></span>&nbsp;<strong>Add New Order</strong></a>
                <a href="index.php?page=7" name="proceed"  class="btn btn-info pull-right btn-sm"   ><strong>Proceed And Checkout</strong> <span class="glyphicon glyphicon-chevron-right"></span></a> 
                --> 
 </div>
                   </div> 
                  <!--reponsive -->

<form action="index.php?q=orderdetails" method="post">
   <a href="index.php?q=product" class="btn btn-default pull-left btn-sm">
   <i class="fa fa-arrow-left fa-fw"></i>
   Add New Order
   </a>

     <?php    
  
                     $countcart =isset($_SESSION['gcCart'])? count($_SESSION['gcCart']) : "0";
                   if ($countcart > 0){
  
                  if (isset($_SESSION['CUSID'])){  
               
                    echo '<button type="submit"  name="proceed" id="proceed" class="btn btn-primary pull-right">
                            Proceed And Checkout
                            <i class="fa  fa-arrow-right fa-fw"></i>
                            </button>';
                 
                   }else{
                     echo   '<a data-target="#smyModal" data-toggle="modal" class="btn btn-primary btn-sm signup pull-right" href="">
                              Proceed And Checkout
                              <i class="fa  fa-arrow-right fa-fw"></i>
                              </a>';
                  } 
                }



                ?>
 </form>
 <?php include "LogSignModal.php"; ?> 