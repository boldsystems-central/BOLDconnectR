generate.batches<-function (data,
                            param.index,
                            batch.size)
  
{
  
  # Extract the ids to a single character file to be used for the url used for POST
  
  
  data=data[,param.index]
  
  
  length.data<-seq_len(length(data))
  
  
  batch.cutoffs=ceiling(length.data/batch.size)
  
  
  batch.indexes=split(length.data,
                      batch.cutoffs)|>
    unname()
  
  
  generate.batch.ids=lapply(batch.indexes,
                            function(x) data[x])
  
  return(generate.batch.ids)
  
}
