import { S3Client, GetObjectCommand } from "@aws-sdk/client-s3";
import { getSignedUrl } from "@aws-sdk/s3-request-presigner";

export const s3 = new S3Client({
  region: process.env.AWS_REGION,
});

export async function getSignedUrlForKey(key) {
  return await getSignedUrl(
    s3,
    new GetObjectCommand({
      Bucket: process.env.S3_BUCKET_NAME,
      Key: key,
    }),
    { expiresIn: 300 } // 5 minutes
  );
}