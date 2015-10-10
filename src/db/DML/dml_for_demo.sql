 // POST: Drawing/Create
        [HttpPost]
        public ActionResult Create(Drawing drawing)
        {
            var time = DateTime.Now;
            drawing.CreateDate = time;
            drawing.ModifiedDate = time;
            if (ModelState.IsValid)
            {
                drawingRepository.CreateNewDrawing(drawing);
                return View();
            }
            return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
        }

 // POST: Drawing/Create
        [HttpPost]
        public ActionResult Create(Drawing drawing)
        {
            var time = DateTime.Now;
            drawing.CreateDate = time;
            drawing.ModifiedDate = time;
            if (ModelState.IsValid)
            {
                drawingRepository.CreateNewDrawing(drawing);
                return View();
            }
            return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
        }