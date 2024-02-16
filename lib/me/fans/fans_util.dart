/**
 *  Copyright (C) 2018-2024
 *  All rights reserved, Designed By www.mailvor.com
 */
getFansFee(feeStr) {
  List fees = feeStr.replaceAll('￥', '').split('#');
  num feeMin = 0;
  num feeMax= 0;
  for(int i= 0; i < fees.length; i++) {
    String fee = fees[i];
    List feeSplit = fee.split('-');
    num fee0 = num.parse(feeSplit[0]);
    feeMin += fee0;
    if(fee.contains('-')) {
      feeMax += num.parse(feeSplit[1]);
    } else {
      if(fee0 > 0) {
        feeMax += fee0;
      }
    }
  }
  if(feeMax != 0) {
    feeStr = '${feeMin.toStringAsFixed(2)}-￥${feeMax.toStringAsFixed(2)}';
  } else {
    feeStr = '￥0';
  }
  return feeStr;
}