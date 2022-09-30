EXECUTE MSDB.DBO.RDS_DOWNLOAD_FROM_S3
      @s3_arn_of_file='arn:aws:s3:::datasetbases1/Catalogos.xml',
      @rds_file_path='D:\S3\Catalogos.xml',
      @overwrite_file=1;

EXECUTE MSDB.DBO.RDS_DOWNLOAD_FROM_S3
      @s3_arn_of_file='arn:aws:s3:::datasetbases1/Operaciones.xml',
      @rds_file_path='D:\S3\Operaciones.xml',
      @overwrite_file=1;
      