data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "buckets" {
  for_each = var.buckets
  bucket   = "${data.aws_caller_identity.current.account_id}-${each.key}"
}

# resource "aws_s3_object" "buckets" {
#   for_each = flatten([
#     for bucket_key, subbuckets in var.buckets : [
#       for subbucket in subbuckets : [
#         { bucket = "${data.aws_caller_identity.current.account_id}-${bucket_key}", key = "${subbucket}/data/raw" },
#         { bucket = "${data.aws_caller_identity.current.account_id}-${bucket_key}", key = "${subbucket}/data/processed" },
#         { bucket = "${data.aws_caller_identity.current.account_id}-${bucket_key}", key = "${subbucket}/data/consumer" }
#       ]
#     ]
#     ])

#   bucket     = each.value.bucket
#   key        = each.value.key
#   depends_on = [aws_s3_bucket.buckets]

# }

# resource "aws_s3_object" "data_folders" {
#   for_each = flatten([
#     for bucket_key, subbuckets in var.buckets : [
#       for subbucket in subbuckets : [
#         {
#           id         = "${bucket_key}_${subbucket}_raw",
#           bucket_key = bucket_key,
#           subbucket  = subbucket,
#           path       = "data/raw"
#         },
#         {
#           id         = "${bucket_key}_${subbucket}_processed",
#           bucket_key = bucket_key,
#           subbucket  = subbucket,
#           path       = "data/processed"
#         },
#         {
#           id         = "${bucket_key}_${subbucket}_consumer",
#           bucket_key = bucket_key,
#           subbucket  = subbucket,
#           path       = "data/consumer"
#         }
#       ]
#     ]
#   ])

#   bucket     = aws_s3_bucket.buckets[each.value.bucket_key].bucket
#   key        = "${each.value.subbucket}/${each.value.path}"
#   depends_on = [aws_s3_bucket.buckets]
# }



locals {
  s3_objects = flatten([
    for bucket_key, subbuckets in var.buckets : [
      for subbucket in subbuckets : [
        {
          id         = "${bucket_key}_${subbucket}_raw",
          bucket_key = bucket_key,
          subbucket  = subbucket,
          path       = "data/raw"
        },
        {
          id         = "${bucket_key}_${subbucket}_processed",
          bucket_key = bucket_key,
          subbucket  = subbucket,
          path       = "data/processed"
        },
        {
          id         = "${bucket_key}_${subbucket}_consumer",
          bucket_key = bucket_key,
          subbucket  = subbucket,
          path       = "data/consumer"
        }
      ]
    ]
  ])
}

resource "aws_s3_object" "data_folders" {
  for_each = { for obj in local.s3_objects : obj.id => obj }

  bucket     = aws_s3_bucket.buckets[each.value.bucket_key].bucket
  key        = "${each.value.subbucket}/${each.value.path}"
  depends_on = [aws_s3_bucket.buckets]
}
