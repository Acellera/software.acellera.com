<?php
$to	 = 'a.varela@acellera.com';
$subject = 'suggestion from software.acellera.com';
$message = $_POST["comment"].'\nfile is at:'.$_FILES["fileToUpload"]["tmp_name"];
$headers = 'From: '. $_POST["email"] . "\r\n" .
    'Reply-To: ' . $_POST["email"] . "\r\n" .
    'X-Mailer: PHP/' . phpversion();

mail($to, $subject, $message, $headers);

$target_dir = "/tmp/";

if (file_exists($_FILES['fileToUpload']['tmp_name'])) {
    $target_file = $target_dir . basename($_FILES["fileToUpload"]["tmp_name"]);
    $uploadOk = 1;
    $imageFileType = strtolower(pathinfo($_FILES["fileToUpload"]["name"],PATHINFO_EXTENSION));
    // Check if image file is a actual image or fake image
    if(isset($_POST["submit"])) {
        $check = getimagesize($_FILES["fileToUpload"]["tmp_name"]);
        if($check !== false) {
            echo "File is an image - " . $check["mime"] . ".";
            $uploadOk = 1;
        } else {
            echo "File is not an image.";
            $uploadOk = 0;
        }
    }

    // Check file size
    if ($_FILES["fileToUpload"]["size"] > 5000000) {
        echo "Sorry, your file is too large.";
        $uploadOk = 0;
    }
    // Allow certain file formats
    if($imageFileType != "jpg" && $imageFileType != "png" && $imageFileType != "jpeg"
    && $imageFileType != "gif" ) {
        echo "Sorry, only JPG, JPEG, PNG & GIF files are allowed.";
        $uploadOk = 0;
    }
    // Check if $uploadOk is set to 0 by an error
    if ($uploadOk == 0) {
        echo "Sorry, your file was not uploaded.";
    // if everything is ok, try to upload file
    } else {
        echo $_FILES["fileToUpload"]["tmp_name"].'-->'.$target_file;
        try {
            move_uploaded_file($_FILES["fileToUpload"]["tmp_name"], $target_file);
        } catch (Exception $e) {
            echo "Sorry, there was a problem uploading your file.";
        }
    }

}

echo 'Thanks for your feedback!. You are being redirected to the page you were using...';
try {
    header('refresh:2;url=' . $_SERVER['HTTP_REFERER']);
    die;
} catch (Exception $e) {
    echo '<br><br>Sorry, we could not track your page, you can click the arrow button to go back';
}

?>

