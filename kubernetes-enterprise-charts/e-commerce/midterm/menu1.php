  <!-- Projects Row -->
  <div class="row">
 
  <table id="home" >
  <thead>
    <tr class="col-md-6 img-portfolio"><td></td></tr>
  </thead>
  
  
<?php   check_message(); ?>

<?php
    // $limit = 10;
 

if(isset($_POST['btnsearch'])) {
  $query = "SELECT * FROM `tblproduct` p  ,`tblcategory` c  WHERE   p.`CATEGID`=c.`CATEGID` AND PROQTY>0 
  AND ( `CATEGORIES` LIKE '%{$_POST['search']}%' OR `PROBRAND` LIKE '%{$_POST['search']}%' OR `PRONAME` LIKE '%{$_POST['search']}%' OR `PRODESC` LIKE '%{$_POST['search']}%' or `PROQTY` LIKE '%{$_POST['search']}%' or `PROPRICE` LIKE '%{$_POST['search']}%')";
}elseif(isset($_GET['category'])){
  $query = "SELECT * FROM `tblproduct` p  ,`tblcategory` c  WHERE   p.`CATEGID`=c.`CATEGID` AND PROQTY>0 AND CATEGORIES='{$_GET['category']}'";
}else{
  $query = "SELECT * FROM `tblproduct` p  ,`tblcategory` c  WHERE   p.`CATEGID`=c.`CATEGID` AND PROQTY>0 ";
}


  $mydb->setQuery($query);
  $cur = $mydb->loadResultList();
  foreach ($cur as $result) { ?>
  
    <tr class="col-md-6 logo" >
        <td class="col-md-12">
          <a href="index.php?q=single-item&id=<?php echo $result->PROID; ?>">
        <img src="<?php echo web_root.'admin/products/'. $result->IMAGES; ?>" alt="<?php echo $result->PRONAME; ?>"> 
        </a> 
        <h3>
            <a href="index.php?q=single-item&id=<?php echo $result->PROID; ?>"><?php echo $result->PRONAME . ' -model::' .$result->PROMODEL . ''; ?></a>
        </h3>
        <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam viverra euismod odio, gravida pellentesque urna varius vitae.</p>
        </td>
      </tr>
 
<?php  }?>

</table>

    </div>
    <!-- /.row -->
