
<div class="row">
         <div class="col-lg-12">
            <h1 class="page-header">Home</h1>
          </div>
          <!-- /.col-lg-12 -->
       </div>
 
   
  <!-- /.panel -->
     <form action="controller.php?action=delete" Method="POST">   
        <div class="row">
                <div class="col-lg-12">
                    <div class="panel panel-default">
                        <div class="panel-heading">
                             <i class="fa fa-list fa-fw"></i>  Products
                               <div class="pull-right">
                                <div class="btn-group">
                                    <button type="button" class="btn btn-default btn-xs dropdown-toggle" data-toggle="dropdown">
                                        Actions
                                        <span class="caret"></span>
                                    </button>
                                    <ul class="dropdown-menu pull-right" role="menu">
                                        <li><a href="#" class="setBanner">Set to Banner</a>
                                        </li>
                                        <li><a href="#">Add Discount</a>
                                        </li>
                                        <li><a href="#">Something else here</a>
                                        </li>
                                        <li class="divider"></li>
                                        <li><a href="#">Separated link</a>
                                        </li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                        <!-- /.panel-heading -->
                        <div class="panel-body">
                            <div class="dataTable_wrapper">
                                                                  
                             <div class="table-responsive">       
                            <table id="dash-table"  class="table table-striped table-bordered table-hover "  style="font-size:12px" cellspacing="0" >
                              
                              <thead>
                                <tr> 
                                  <!-- <th>#</th> -->
                                   <th>Model</th> 
                                  <!--<th  ><input type="checkbox" name="chkall" id="chkall" onclick="return checkall('selector[]');"> Model</th>  -->
                                  <th>Product</th> 
                                  <th>Description</th>
                                  <!-- <th>Category</th> -->
                                  <th>Price</th>
                                  <th>Quantity</th>  
                                  <!-- <th width="6%">Action</th>  -->
                                   
                                </tr> 
                              </thead>  

                            <tbody>
                                <?php 
                                  $query = "SELECT * FROM `tblproduct` p  ,`tblcategory` c 
                                      WHERE   p.`CATEGID`=c.`CATEGID`";
                                  $mydb->setQuery($query);
                                  $cur = $mydb->loadResultList();

                                foreach ($cur as $result) { 
                                  echo '<tr>';
                                  echo '<td><a title="edit" href="'.web_root.'admin/products/index.php?view=edit&id='.$result->PROID.'">' . $result->PROMODEL.'</a></td>';
                                  echo '<td>'.$result->PRONAME.' '. $result->CATEGORIES.'</a></td>';
                                  
                                  echo '<td>'. $result->PRODESC.'</td>'; 
                                  // echo '<td>'. $result->CATEGORIES.'</td>'; 
                                  echo '<td> &#8369 '.  number_format($result->PROPRICE,2).'</td>';
                                  echo '<td >'. $result->PROQTY.'</td>'; 
                                  
                                  }
                                ?>
                              </tbody>
                              
                              
                            </table>
 
                           </div>   
 
                         
                        </div>
                        <!-- /.panel-body -->
                    </div>
                    <!-- /.panel -->
                </div>
                <!-- /.col-lg-12 -->
            </div>
            <!-- /.row -->
     </div>
    </form>
  