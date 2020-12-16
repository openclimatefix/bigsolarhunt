double gpsDMSToDeg(List<dynamic> gpsDMS, String gpsDMSRef) {
  // Convert day/minute/second coordinates to degrees if exists, else return null
  if (gpsDMS == null || gpsDMSRef == null) {
    return null;
  } else {
    double result = gpsDMS[0].numerator / gpsDMS[0].denominator;
    result += (gpsDMS[1].numerator / gpsDMS[1].denominator) / 60;
    result += (gpsDMS[2].numerator / gpsDMS[2].denominator) / (60 * 60);
    if (gpsDMSRef == "S" || gpsDMSRef == "W") {
      result = result * -1;
    }
    print(result);
    return result;
  }
}
