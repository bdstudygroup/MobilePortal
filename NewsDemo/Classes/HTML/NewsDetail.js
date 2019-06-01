window.onload = function(){
    var imageArray = document.getElementsByTagName('img');
    for(var p in  imageArray){
        imageArray[p].style.width = '100%%';
        imageArray[p].style.height ='auto'
    }
    for(var i=0; i < imageArray.length; i++)
    {
        var image = imageArray[i];
        image.index = i;
        image.onclick = function(){
            alert(imageArray[image.index]);
            window.webkit.messageHandlers.openBigPicture.postMessage({methodName:"openBigPicture:",imageSrc:imageArray[this.index].src});
        }
    }
}